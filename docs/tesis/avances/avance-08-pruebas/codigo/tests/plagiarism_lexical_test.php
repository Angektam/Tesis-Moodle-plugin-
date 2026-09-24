<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\plagiarism;

defined('MOODLE_INTERNAL') || die();

/**
 * Tests unitarios para el analizador léxico de plagio (mejora #1).
 *
 * @package    mod_aiassignment
 * @category   test
 * @covers     \mod_aiassignment\plagiarism\lexical_analyzer
 */
class plagiarism_lexical_test extends \advanced_testcase {

    public function test_identical_code_returns_high_similarity(): void {
        $code = "def fibonacci(n):\n    if n <= 1:\n        return n\n    return fibonacci(n-1) + fibonacci(n-2)";
        $result = lexical_analyzer::similarity($code, $code);
        $this->assertGreaterThan(90, $result['score']);
    }

    public function test_completely_different_code_returns_low_similarity(): void {
        $code1 = "def fibonacci(n):\n    if n <= 1:\n        return n\n    return fibonacci(n-1) + fibonacci(n-2)";
        $code2 = "SELECT * FROM users WHERE age > 18 ORDER BY name ASC LIMIT 10";
        $result = lexical_analyzer::similarity($code1, $code2);
        $this->assertLessThan(30, $result['score']);
    }

    public function test_renamed_variables_detected(): void {
        $code1 = "def calc(x):\n    result = x * 2\n    return result";
        $code2 = "def compute(y):\n    output = y * 2\n    return output";
        $result = lexical_analyzer::similarity($code1, $code2);
        // Después de normalización, deberían ser similares
        $this->assertGreaterThan(50, $result['score']);
    }

    public function test_normalize_identifiers_removes_comments(): void {
        $code = "// This is a comment\ndef hello():\n    # Python comment\n    return 1";
        $normalized = lexical_analyzer::normalize_identifiers($code);
        $this->assertStringNotContainsString('This is a comment', $normalized);
        $this->assertStringNotContainsString('Python comment', $normalized);
    }

    public function test_normalize_identifiers_replaces_strings(): void {
        $code = 'print("Hello World")';
        $normalized = lexical_analyzer::normalize_identifiers($code);
        $this->assertStringContainsString('"STR"', $normalized);
        $this->assertStringNotContainsString('Hello World', $normalized);
    }

    public function test_normalize_identifiers_replaces_numbers(): void {
        $code = 'x = 42 + 3.14';
        $normalized = lexical_analyzer::normalize_identifiers($code);
        $this->assertStringContainsString('NUM', $normalized);
        $this->assertStringNotContainsString('42', $normalized);
    }

    public function test_tokenize_splits_correctly(): void {
        $tokens = lexical_analyzer::tokenize('if (x > 0) { return x; }');
        $this->assertNotEmpty($tokens);
        $this->assertContains('if', $tokens);
        $this->assertContains('return', $tokens);
    }

    public function test_jaccard_identical_arrays(): void {
        $a = ['a', 'b', 'c'];
        $this->assertEquals(1.0, lexical_analyzer::jaccard($a, $a));
    }

    public function test_jaccard_empty_arrays(): void {
        $this->assertEquals(1.0, lexical_analyzer::jaccard([], []));
        $this->assertEquals(0.0, lexical_analyzer::jaccard(['a'], []));
    }

    public function test_jaccard_disjoint_arrays(): void {
        $result = lexical_analyzer::jaccard(['a', 'b'], ['c', 'd']);
        $this->assertEquals(0.0, $result);
    }

    public function test_lcs_ratio_identical(): void {
        $a = ['a', 'b', 'c'];
        $this->assertEquals(1.0, lexical_analyzer::lcs_ratio($a, $a));
    }

    public function test_lcs_ratio_empty(): void {
        $this->assertEquals(1.0, lexical_analyzer::lcs_ratio([], []));
        $this->assertEquals(0.0, lexical_analyzer::lcs_ratio(['a'], []));
    }

    public function test_levenshtein_ratio_identical(): void {
        $this->assertEquals(1.0, lexical_analyzer::levenshtein_ratio('hello', 'hello'));
    }

    public function test_levenshtein_ratio_different(): void {
        $result = lexical_analyzer::levenshtein_ratio('hello', 'world');
        $this->assertLessThan(0.5, $result);
    }

    public function test_levenshtein_ratio_empty(): void {
        $this->assertEquals(1.0, lexical_analyzer::levenshtein_ratio('', ''));
        $this->assertEquals(0.0, lexical_analyzer::levenshtein_ratio('hello', ''));
    }

    public function test_bigrams_generation(): void {
        $tokens = ['a', 'b', 'c', 'd'];
        $bigrams = lexical_analyzer::bigrams($tokens);
        $this->assertCount(3, $bigrams);
        $this->assertEquals('a|b', $bigrams[0]);
        $this->assertEquals('b|c', $bigrams[1]);
        $this->assertEquals('c|d', $bigrams[2]);
    }

    public function test_similarity_returns_all_metrics(): void {
        $code1 = "def hello():\n    return 'hi'";
        $code2 = "def greet():\n    return 'hey'";
        $result = lexical_analyzer::similarity($code1, $code2);

        $this->assertArrayHasKey('score', $result);
        $this->assertArrayHasKey('jaccard', $result);
        $this->assertArrayHasKey('lcs', $result);
        $this->assertArrayHasKey('levenshtein', $result);
        $this->assertArrayHasKey('norm1', $result);
        $this->assertArrayHasKey('norm2', $result);
        $this->assertArrayHasKey('tokens1', $result);
        $this->assertArrayHasKey('tokens2', $result);
    }
}
