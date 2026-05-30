import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onLogin,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == 'teste' && password == 'teste') {
      widget.onLogin();
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('Use teste nos dois campos para entrar.')),
      );
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe $fieldName.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: colorScheme.primaryContainer,
                              child: Icon(
                                Icons.inventory_2,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sistema Supplier',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const Text('Controle de fornecedores'),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: widget.isDarkMode
                                  ? 'Usar modo claro'
                                  : 'Usar modo escuro',
                              onPressed: widget.onToggleTheme,
                              icon: Icon(
                                widget.isDarkMode
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Para teste, entre com teste nos campos de email e senha.',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.mail),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              _validateRequired(value, 'o email'),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              tooltip: _hidePassword
                                  ? 'Mostrar senha'
                                  : 'Ocultar senha',
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          validator: (value) =>
                              _validateRequired(value, 'a senha'),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.login),
                          label: const Text('Entrar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
