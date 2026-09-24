<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Tests unitarios para security::detect_language().
 * Cubre los 10 lenguajes soportados + casos borde.
 *
 * @package    mod_aiassignment
 * @category   test
 * @covers     \mod_aiassignment\security::detect_language
 */
class language_detection_test extends \advanced_testcase {

    // ── Python ───────────────────────────────────────────────────────────────

    public function test_python_def_and_elif(): void {
        $code = "def fibonacci(n):\n    if n <= 1:\n        return n\n    elif n == 2:\n        return 1\n    return fibonacci(n-1) + fibonacci(n-2)";
        $this->assertSame('python', security::detect_language($code));
    }

    public function test_python_from_import(): void {
        $code = "from collections import Counter\ndef count_words(text):\n    return Counter(text.split())";
        $this->assertSame('python', security::detect_language($code));
    }

    public function test_python_print_and_def(): void {
        $code = "def greet(name):\n    print('Hello', name)\ngreet('World')";
        $this->assertSame('python', security::detect_language($code));
    }

    // ── JavaScript ───────────────────────────────────────────────────────────

    public function test_javascript_console_log_and_const(): void {
        $code = "const greet = (name) => {\n    console.log('Hello', name);\n};\ngreet('World');";
        $this->assertSame('javascript', security::detect_language($code));
    }

    public function test_javascript_require_and_function(): void {
        $code = "const fs = require('fs');\nfunction readFile(path) {\n    return fs.readFileSync(path, 'utf8');\n}";
        $this->assertSame('javascript', security::detect_language($code));
    }

    // ── TypeScript ───────────────────────────────────────────────────────────

    public function test_typescript_interface_and_types(): void {
        $code = "interface User {\n    name: string;\n    age: number;\n}\nfunction greet(user: User): void {\n    console.log(user.name);\n}";
        $this->assertSame('typescript', security::detect_language($code));
    }

    public function test_typescript_enum(): void {
        $code = "enum Status { Active, Inactive }\nconst s: Status = Status.Active;\nconst name: string = 'test';";
        $this->assertSame('typescript', security::detect_language($code));
    }

    // ── Java ─────────────────────────────────────────────────────────────────

    public function test_java_public_class(): void {
        $code = "public class HelloWorld {\n    public static void main(String[] args) {\n        System.out.println(\"Hello\");\n    }\n}";
        $this->assertSame('java', security::detect_language($code));
    }

    public function test_java_import_java(): void {
        $code = "import java.util.ArrayList;\npublic class MyList {\n    ArrayList<String> list = new ArrayList<>();\n}";
        $this->assertSame('java', security::detect_language($code));
    }

    // ── C / C++ ──────────────────────────────────────────────────────────────

    public function test_c_include_and_main(): void {
        $code = "#include <stdio.h>\nint main() {\n    printf(\"Hello World\\n\");\n    return 0;\n}";
        $this->assertSame('cpp', security::detect_language($code));
    }

    public function test_cpp_cout(): void {
        $code = "#include <iostream>\nusing namespace std;\nint main() {\n    cout << \"Hello\" << endl;\n    return 0;\n}";
        $this->assertSame('cpp', security::detect_language($code));
    }

    // ── PHP ──────────────────────────────────────────────────────────────────

    public function test_php_opening_tag(): void {
        $code = "<?php\n\$name = 'World';\necho 'Hello ' . \$name;";
        $this->assertSame('php', security::detect_language($code));
    }

    // ── SQL ──────────────────────────────────────────────────────────────────

    public function test_sql_select_from_where(): void {
        $code = "SELECT u.name, u.email FROM users u WHERE u.age > 18 ORDER BY u.name ASC;";
        $this->assertSame('sql', security::detect_language($code));
    }

    public function test_sql_join(): void {
        $code = "SELECT e.nombre, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id = c.estudiante_id WHERE c.calificacion >= 70;";
        $this->assertSame('sql', security::detect_language($code));
    }

    // ── Ruby ─────────────────────────────────────────────────────────────────

    public function test_ruby_def_end_puts(): void {
        $code = "def greet(name)\n    puts \"Hello #{name}\"\nend\ngreet('World')";
        $this->assertSame('ruby', security::detect_language($code));
    }

    // ── Go ───────────────────────────────────────────────────────────────────

    public function test_go_func_and_fmt(): void {
        $code = "package main\nimport \"fmt\"\nfunc main() {\n    fmt.Println(\"Hello World\")\n}";
        $this->assertSame('go', security::detect_language($code));
    }

    // ── Rust ─────────────────────────────────────────────────────────────────

    public function test_rust_fn_and_println(): void {
        $code = "fn main() {\n    let mut x = 5;\n    println!(\"x = {}\", x);\n}";
        $this->assertSame('rust', security::detect_language($code));
    }

    // ── Casos borde ──────────────────────────────────────────────────────────

    public function test_empty_code_returns_empty(): void {
        $this->assertSame('', security::detect_language(''));
    }

    public function test_very_short_code_returns_empty(): void {
        $this->assertSame('', security::detect_language('x = 1'));
    }

    public function test_plain_text_returns_empty(): void {
        $code = "Este es un texto en español sin código de programación.";
        $this->assertSame('', security::detect_language($code));
    }

    /**
     * TypeScript NO debe detectarse como JavaScript cuando tiene señales TS fuertes.
     */
    public function test_typescript_not_confused_with_javascript(): void {
        $code = "interface Config {\n    host: string;\n    port: number;\n}\nexport default class Server {\n    constructor(private config: Config) {}\n}";
        $detected = security::detect_language($code);
        // Debe ser typescript, no javascript
        $this->assertSame('typescript', $detected);
    }

    /**
     * Python con solo 1 señal débil no debe detectarse con certeza.
     * (La función requiere >= 2 señales o 1 señal fuerte)
     */
    public function test_python_single_weak_signal_still_detected(): void {
        $code = "def hello():\n    pass";
        // def + : son señales Python
        $this->assertSame('python', security::detect_language($code));
    }
}
