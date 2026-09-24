<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\plagiarism;

defined('MOODLE_INTERNAL') || die();

/**
 * Tests unitarios para el analizador estructural de plagio.
 *
 * @package    mod_aiassignment
 * @category   test
 * @covers     \mod_aiassignment\plagiarism\structural_analyzer
 */
class plagiarism_structural_test extends \advanced_testcase {

    public function test_detect_python_language(): void {
        $code = "def fibonacci(n):\n    if n <= 1:\n        return n\n    return fibonacci(n-1) + fibonacci(n-2)";
        $this->assertEquals('python', structural_analyzer::detect_language($code));
    }

    public function test_detect_java_language(): void {
        $code = "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello\");\n    }\n}";
        $this->assertEquals('java', structural_analyzer::detect_language($code));
    }

    public function test_detect_javascript_language(): void {
        $code = "const greet = (name) => {\n    console.log(`Hello ${name}`);\n};";
        $this->assertEquals('javascript', structural_analyzer::detect_language($code));
    }

    public function test_detect_c_language(): void {
        $code = "#include <stdio.h>\nint main() {\n    printf(\"Hello\");\n    return 0;\n}";
        $this->assertEquals('c_cpp', structural_analyzer::detect_language($code));
    }

    public function test_detect_php_language(): void {
        $code = "<?php\n\$name = 'World';\necho \"Hello \$name\";";
        $this->assertEquals('php', structural_analyzer::detect_language($code));
    }

    public function test_is_python_true(): void {
        $this->assertTrue(structural_analyzer::is_python("def hello():\n    print('hi')"));
    }

    public function test_is_python_false(): void {
        $this->assertFalse(structural_analyzer::is_python("function hello() { return 'hi'; }"));
    }

    public function test_extract_features_counts_functions(): void {
        $code = "def foo():\n    pass\ndef bar():\n    pass";
        $features = structural_analyzer::extract_features($code);
        $this->assertGreaterThanOrEqual(2, $features['functions']);
    }

    public function test_extract_features_counts_loops(): void {
        $code = "for i in range(10):\n    while True:\n        break";
        $features = structural_analyzer::extract_features($code);
        $this->assertGreaterThanOrEqual(2, $features['loops']);
    }

    public function test_extract_features_counts_conditionals(): void {
        $code = "if x > 0:\n    pass\nelif x < 0:\n    pass";
        $features = structural_analyzer::extract_features($code);
        $this->assertGreaterThanOrEqual(2, $features['conditionals']);
    }

    public function test_extract_features_detects_language(): void {
        $code = "def hello():\n    print('hi')";
        $features = structural_analyzer::extract_features($code);
        $this->assertEquals('python', $features['language']);
    }

    public function test_similarity_identical_code(): void {
        $code = "function add(a, b) { return a + b; }";
        $result = structural_analyzer::similarity($code, $code);
        $this->assertGreaterThan(80, $result['score']);
    }

    public function test_similarity_different_code(): void {
        $code1 = "for (int i = 0; i < 10; i++) { printf(\"%d\", i); }";
        $code2 = "SELECT name, age FROM students WHERE grade = 'A'";
        $result = structural_analyzer::similarity($code1, $code2);
        $this->assertLessThan(60, $result['score']);
    }

    public function test_similarity_returns_method(): void {
        $code = "x = 1 + 2";
        $result = structural_analyzer::similarity($code, $code);
        $this->assertArrayHasKey('method', $result);
    }

    public function test_java_features_include_classes(): void {
        $code = "public class MyClass {\n    public void method() {}\n}\ninterface MyInterface {}";
        $features = structural_analyzer::extract_features($code);
        $this->assertArrayHasKey('classes', $features);
        $this->assertArrayHasKey('interfaces', $features);
    }

    public function test_python_features_include_decorators(): void {
        $code = "import os\n@staticmethod\ndef hello():\n    with open('f') as f:\n        x = [i for i in range(10)]";
        $features = structural_analyzer::extract_features($code);
        $this->assertArrayHasKey('decorators', $features);
        $this->assertArrayHasKey('with_stmts', $features);
        $this->assertArrayHasKey('list_compr', $features);
    }
}
