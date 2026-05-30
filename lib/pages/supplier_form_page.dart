import 'package:flutter/material.dart';

import '../models/supplier.dart';

class SupplierFormPage extends StatefulWidget {
  const SupplierFormPage({super.key, this.supplier});

  final Supplier? supplier;

  @override
  State<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends State<SupplierFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _cnpjController;
  late final TextEditingController _phoneController;
  late final TextEditingController _descriptionController;

  bool get _isEditing => widget.supplier != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier?.name ?? '');
    _cnpjController = TextEditingController(text: widget.supplier?.cnpj ?? '');
    _phoneController = TextEditingController(
      text: widget.supplier?.phone ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.supplier?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cnpjController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final supplier = Supplier(
      id:
          widget.supplier?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      cnpj: _cnpjController.text.trim(),
      phone: _phoneController.text.trim(),
      description: _descriptionController.text.trim(),
      contractDate: widget.supplier?.contractDate ?? DateTime.now(),
    );

    Navigator.of(context).pop(supplier);
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe $fieldName.';
    }
    return null;
  }

  String? _validateCnpj(String? value) {
    final requiredMessage = _validateRequired(value, 'o CNPJ');
    if (requiredMessage != null) {
      return requiredMessage;
    }

    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 14) {
      return 'O CNPJ deve conter 14 numeros.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final requiredMessage = _validateRequired(value, 'o telefone');
    if (requiredMessage != null) {
      return requiredMessage;
    }

    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 11) {
      return 'O telefone deve ter 10 ou 11 numeros.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar fornecedor' : 'Novo fornecedor'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(Icons.business),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) => _validateRequired(value, 'o nome'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cnpjController,
                    decoration: const InputDecoration(
                      labelText: 'CNPJ ficticio',
                      hintText: '00.000.000/0000-00',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: _validateCnpj,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      hintText: '(00) 00000-0000',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descricao',
                      hintText:
                          'Ex.: fornecedor de pecas, alimentos, servicos...',
                      prefixIcon: Icon(Icons.description),
                    ),
                    minLines: 3,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    validator: (value) =>
                        _validateRequired(value, 'a descricao'),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save),
                    label: Text(_isEditing ? 'Salvar alteracoes' : 'Cadastrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
