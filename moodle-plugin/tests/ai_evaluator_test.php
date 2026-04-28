<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Tests unitarios para ai_evaluator (mejora #1).
 * Prueba el modo demo (sin API real).
 *
 * @package    mod_aiassignment
 * @category   test
 * @covers     \mod_aiassignment\ai_evaluator
 */
class ai_evaluator_test extends \advanced_testcase {

    protected function setUp(): void {
        parent::setUp();
        $this->resetAfterTest();
        // Activar modo demo para tests sin API
        set_config('demo_mode', 1, 'mod_aiassignment');
    }

    public function test_evaluate_programming_returns_valid_structure(): void {
        $student = "def fibonacci(n):\n    if n <= 1:\n        return n\n    return fibonacci(n-1) + fibonacci(n-2)";
        $teacher = "def fib(n):\n    if n <= 1:\n        return n\n    return fib(n-1) + fib(n-2)";

        $result = ai_evaluator::evaluate($student, $teacher, 'programming');

        $this->assertArrayHasKey('similarity_score', $result);
        $this->assertArrayHasKey('feedback', $result);
        $this->assertArrayHasKey('analysis', $result);
        $this->assertArrayHasKey('confidence', $result);
        $this->assertArrayHasKey('errors', $result);
    }

    public function test_evaluate_score_in_valid_range(): void {
        $result = ai_evaluator::evaluate('x = 1 + 2', 'x = 1 + 2', 'programming');
        $this->assertGreaterThanOrEqual(0, $result['similarity_score']);
        $this->assertLessThanOrEqual(100, $result['similarity_score']);
    }

    public function test_evaluate_math_type(): void {
        $result = ai_evaluator::evaluate('x = 5, resultado = 25', 'x² = 25', 'math');
        $this->assertArrayHasKey('similarity_score', $result);
        $this->assertNotEmpty($result['feedback']);
    }

    public function test_evaluate_sql_type(): void {
        $result = ai_evaluator::evaluate(
            'SELECT name FROM users WHERE age > 18',
            'SELECT name FROM users WHERE age > 18 ORDER BY name',
            'sql'
        );
        $this->assertArrayHasKey('similarity_score', $result);
    }

    public function test_evaluate_essay_type(): void {
        $result = ai_evaluator::evaluate(
            'La inteligencia artificial es una rama de la informática porque estudia algoritmos.',
            'La IA es un campo de la ciencia de la computación que busca crear sistemas inteligentes.',
            'essay'
        );
        $this->assertArrayHasKey('similarity_score', $result);
    }

    public function test_evaluate_caches_result(): void {
        $student = "def test():\n    return 42";
        $teacher = "def test():\n    return 42";

        $result1 = ai_evaluator::evaluate($student, $teacher, 'programming');
        $result2 = ai_evaluator::evaluate($student, $teacher, 'programming');

        $this->assertTrue($result2['from_cache'] ?? false);
    }

    public function test_evaluate_demo_confidence_is_low(): void {
        $result = ai_evaluator::evaluate('x = 1', 'x = 1', 'programming');
        $this->assertEquals(60, $result['confidence']);
    }

    public function test_render_errors_empty(): void {
        $html = ai_evaluator::render_errors([]);
        $this->assertEmpty($html);
    }

    public function test_render_errors_with_data(): void {
        $errors = [
            ['line' => 'Línea 5', 'issue' => 'Falta return', 'suggestion' => 'Agrega return'],
        ];
        $html = ai_evaluator::render_errors($errors);
        $this->assertStringContainsString('Línea 5', $html);
        $this->assertStringContainsString('Falta return', $html);
        $this->assertStringContainsString('Agrega return', $html);
    }

    public function test_render_confidence_high(): void {
        $html = ai_evaluator::render_confidence(90);
        $this->assertStringContainsString('Alta', $html);
        $this->assertStringContainsString('#28a745', $html);
    }

    public function test_render_confidence_medium(): void {
        $html = ai_evaluator::render_confidence(65);
        $this->assertStringContainsString('Media', $html);
    }

    public function test_render_confidence_low(): void {
        $html = ai_evaluator::render_confidence(40);
        $this->assertStringContainsString('Baja', $html);
        $this->assertStringContainsString('#dc3545', $html);
    }

    /**
     * @dataProvider typeProvider
     */
    public function test_evaluate_all_types(string $type): void {
        $result = ai_evaluator::evaluate('test answer content here', 'reference solution here', $type);
        $this->assertArrayHasKey('similarity_score', $result);
        $this->assertIsFloat($result['similarity_score']);
    }

    public static function typeProvider(): array {
        return [
            'programming' => ['programming'],
            'math'        => ['math'],
            'essay'       => ['essay'],
            'sql'         => ['sql'],
            'pseudocode'  => ['pseudocode'],
            'debugging'   => ['debugging'],
        ];
    }
}
