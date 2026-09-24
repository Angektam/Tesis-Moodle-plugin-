<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\plagiarism;

defined('MOODLE_INTERNAL') || die();

/**
 * Tests unitarios para el detector de ofuscación.
 *
 * @package    mod_aiassignment
 * @category   test
 * @covers     \mod_aiassignment\plagiarism\obfuscation_detector
 */
class obfuscation_detector_test extends \advanced_testcase {

    public function test_normalize_operators_increment(): void {
        $this->assertStringContainsString('i+=1', obfuscation_detector::normalize_operators('i++'));
        $this->assertStringContainsString('i-=1', obfuscation_detector::normalize_operators('i--'));
    }

    public function test_normalize_operators_assignment(): void {
        $this->assertStringContainsString('i+=1', obfuscation_detector::normalize_operators('i = i + 1'));
        $this->assertStringContainsString('i-=1', obfuscation_detector::normalize_operators('i = i - 1'));
    }

    public function test_normalize_operators_booleans(): void {
        $this->assertStringContainsString('true', obfuscation_detector::normalize_operators('True'));
        $this->assertStringContainsString('false', obfuscation_detector::normalize_operators('False'));
        $this->assertStringContainsString('null', obfuscation_detector::normalize_operators('None'));
    }

    public function test_comment_ratio_no_comments(): void {
        $code = "x = 1\ny = 2\nz = x + y";
        $ratio = obfuscation_detector::comment_ratio($code);
        $this->assertEquals(0.0, $ratio);
    }

    public function test_comment_ratio_all_comments(): void {
        $code = "# comment 1\n# comment 2\n# comment 3";
        $ratio = obfuscation_detector::comment_ratio($code);
        $this->assertEquals(1.0, $ratio);
    }

    public function test_comment_ratio_mixed(): void {
        $code = "# comment\nx = 1\ny = 2\n# another comment";
        $ratio = obfuscation_detector::comment_ratio($code);
        $this->assertEquals(0.5, $ratio);
    }

    public function test_detect_returns_array(): void {
        $code1 = "def foo():\n    return 1";
        $code2 = "def bar():\n    return 2";
        $lex = lexical_analyzer::similarity($code1, $code2);
        $struct = structural_analyzer::similarity($code1, $code2);
        $techniques = obfuscation_detector::detect($code1, $code2, $lex, $struct);
        $this->assertIsArray($techniques);
    }

    public function test_detect_variable_renaming(): void {
        // Código con misma estructura pero variables renombradas
        $code1 = "def calculate(value):\n    result = value * 2\n    total = result + 10\n    return total";
        $code2 = "def compute(num):\n    output = num * 2\n    sum = output + 10\n    return sum";
        $lex = ['score' => 75, 'jaccard' => 30, 'lcs' => 65, 'levenshtein' => 60];
        $struct = ['score' => 90, 'features1' => ['loops' => 0], 'features2' => ['loops' => 0]];
        $techniques = obfuscation_detector::detect($code1, $code2, $lex, $struct);
        // Debería detectar renombrado
        $found = false;
        foreach ($techniques as $t) {
            if (stripos($t, 'renombrad') !== false) {
                $found = true;
                break;
            }
        }
        $this->assertTrue($found, 'Debería detectar renombrado de variables');
    }

    public function test_detect_dead_code_insertion(): void {
        $code1 = "x = 1";
        $code2 = "x = 1\n" . str_repeat("# padding line\n", 20);
        $lex = ['score' => 60, 'jaccard' => 55, 'lcs' => 60, 'levenshtein' => 40];
        $struct = ['score' => 80, 'features1' => ['loops' => 0], 'features2' => ['loops' => 0]];
        $techniques = obfuscation_detector::detect($code1, $code2, $lex, $struct);
        $found = false;
        foreach ($techniques as $t) {
            if (stripos($t, 'código muerto') !== false || stripos($t, 'padding') !== false) {
                $found = true;
                break;
            }
        }
        $this->assertTrue($found, 'Debería detectar inserción de código muerto');
    }
}
