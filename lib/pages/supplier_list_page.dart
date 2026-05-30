import 'package:flutter/material.dart';

import '../models/supplier.dart';
import '../repositories/supplier_repository.dart';
import 'supplier_form_page.dart';

class SupplierListPage extends StatefulWidget {
  const SupplierListPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onLogout,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  @override
  State<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends State<SupplierListPage> {
  final SupplierRepository _repository = SupplierRepository();
  List<Supplier> _suppliers = [];
  bool _isLoading = true;
  int _selectedView = 0;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    final loadedSuppliers = await _repository.loadSuppliers();
    if (!mounted) {
      return;
    }

    setState(() {
      _suppliers = loadedSuppliers;
      _isLoading = false;
    });
  }

  Future<void> _saveCurrentList() async {
    await _repository.saveSuppliers(_suppliers);
  }

  Future<void> _openForm({Supplier? supplier}) async {
    final savedSupplier = await Navigator.of(context).push<Supplier>(
      MaterialPageRoute(builder: (_) => SupplierFormPage(supplier: supplier)),
    );

    if (savedSupplier == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      final supplierIndex = _suppliers.indexWhere(
        (item) => item.id == savedSupplier.id,
      );

      if (supplierIndex >= 0) {
        _suppliers[supplierIndex] = savedSupplier;
      } else {
        _suppliers.add(savedSupplier);
      }
    });

    await _saveCurrentList();
    _showMessage(
      supplier == null
          ? 'Fornecedor cadastrado com sucesso.'
          : 'Fornecedor alterado com sucesso.',
    );
  }

  Future<void> _removeSupplier(Supplier supplier) async {
    final confirmed = await _confirm(
      title: 'Remover fornecedor',
      message: 'Deseja remover ${supplier.name}?',
      confirmText: 'Remover',
    );

    if (!confirmed) {
      return;
    }

    setState(() {
      _suppliers.removeWhere((item) => item.id == supplier.id);
    });

    await _saveCurrentList();
    _showMessage('Fornecedor removido com sucesso.');
  }

  Future<void> _clearSuppliers() async {
    if (_suppliers.isEmpty) {
      _showMessage('Nao ha fornecedores para limpar.');
      return;
    }

    final confirmed = await _confirm(
      title: 'Limpar dados',
      message: 'Deseja apagar todos os fornecedores cadastrados?',
      confirmText: 'Limpar',
    );

    if (!confirmed) {
      return;
    }

    setState(() {
      _suppliers = [];
    });

    await _repository.clearSuppliers();
    _showMessage('Dados limpos com sucesso.');
  }

  Future<void> _reorderSuppliers(int oldIndex, int newIndex) async {
    setState(() {
      final movedSupplier = _suppliers.removeAt(oldIndex);
      _suppliers.insert(newIndex, movedSupplier);
    });

    await _saveCurrentList();
    _showMessage('Ordem dos fornecedores atualizada.');
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSupportDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Atendimento'),
          content: const SelectableText(
            'Para falar com o SAC, envie um email para atendimento@sistema.com.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 760;

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedView == 0 ? 'Fornecedores' : 'Estoque completo'),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode ? 'Modo claro' : 'Modo escuro',
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(
            tooltip: 'SAC',
            onPressed: _showSupportDialog,
            icon: const Icon(Icons.support_agent),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: isCompact ? _buildDrawer() : null,
      body: SafeArea(
        child: Row(
          children: [
            if (!isCompact) _buildSidebar(),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Fornecedor'),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(child: SafeArea(child: _buildMenuButtons(isDrawer: true)));
  }

  Widget _buildSidebar() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(right: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: _buildMenuButtons(),
    );
  }

  Widget _buildMenuButtons({bool isDrawer = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isDrawer) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              child: Text(
                'Sistema Supplier',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
          _MenuButton(
            icon: Icons.dashboard,
            label: 'Painel',
            selected: _selectedView == 0,
            onPressed: () => _selectView(0, closeDrawer: isDrawer),
          ),
          const SizedBox(height: 8),
          _MenuButton(
            icon: Icons.view_list,
            label: 'Estoque completo',
            selected: _selectedView == 1,
            onPressed: () => _selectView(1, closeDrawer: isDrawer),
          ),
          const SizedBox(height: 8),
          _MenuButton(
            icon: Icons.add_business,
            label: 'Novo fornecedor',
            selected: false,
            onPressed: () {
              if (isDrawer) {
                Navigator.of(context).pop();
              }
              _openForm();
            },
          ),
          const SizedBox(height: 8),
          _MenuButton(
            icon: Icons.delete_sweep,
            label: 'Limpar dados',
            selected: false,
            onPressed: () {
              if (isDrawer) {
                Navigator.of(context).pop();
              }
              _clearSuppliers();
            },
          ),
          const Spacer(),
          _MenuButton(
            icon: widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            label: widget.isDarkMode ? 'Modo claro' : 'Modo escuro',
            selected: false,
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(height: 8),
          _MenuButton(
            icon: Icons.support_agent,
            label: 'SAC',
            selected: false,
            onPressed: () {
              if (isDrawer) {
                Navigator.of(context).pop();
              }
              _showSupportDialog();
            },
          ),
          const SizedBox(height: 8),
          _MenuButton(
            icon: Icons.logout,
            label: 'Sair',
            selected: false,
            onPressed: widget.onLogout,
          ),
        ],
      ),
    );
  }

  void _selectView(int view, {required bool closeDrawer}) {
    setState(() {
      _selectedView = view;
    });

    if (closeDrawer) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_selectedView == 1) {
      return _buildFullInventory();
    }

    return _buildDashboard();
  }

  Widget _buildDashboard() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        _buildSummaryHeader(),
        const SizedBox(height: 16),
        if (_suppliers.isEmpty) _buildEmptyState() else _buildSupplierList(),
      ],
    );
  }

  Widget _buildSummaryHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useColumns = constraints.maxWidth >= 720;

        final cards = [
          _SummaryCard(
            icon: Icons.business,
            label: 'Fornecedores',
            value: _suppliers.length.toString(),
          ),
          _SummaryCard(
            icon: Icons.assignment_turned_in,
            label: 'Registros salvos',
            value: _suppliers.length.toString(),
          ),
          const _SummaryCard(
            icon: Icons.mark_email_unread,
            label: 'SAC',
            value: 'atendimento@sistema.com',
          ),
        ];

        if (!useColumns) {
          return Column(
            children: [
              for (final card in cards) ...[
                card,
                if (card != cards.last) const SizedBox(height: 8),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (final card in cards) ...[
              Expanded(child: card),
              if (card != cards.last) const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 72,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum fornecedor cadastrado',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Use o botao adicionar para registrar nome, CNPJ ficticio, telefone e descricao.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierList() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: _suppliers.length,
      onReorderItem: _reorderSuppliers,
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1, end: 1.02).animate(animation),
            child: child,
          ),
        );
      },
      itemBuilder: (context, index) {
        final supplier = _suppliers[index];

        return Padding(
          key: ValueKey(supplier.id),
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            elevation: 0,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  supplier.name.trim().isEmpty
                      ? '?'
                      : supplier.name.trim()[0].toUpperCase(),
                ),
              ),
              title: Text(supplier.name),
              subtitle: Text(
                'CNPJ: ${supplier.cnpj}\n'
                'Telefone: ${supplier.phone}\n'
                'Descricao: ${supplier.description}\n'
                'Contrato: ${_formatDate(supplier.contractDate)}',
              ),
              isThreeLine: false,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Editar',
                    onPressed: () => _openForm(supplier: supplier),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    tooltip: 'Remover',
                    onPressed: () => _removeSupplier(supplier),
                    icon: const Icon(Icons.delete),
                  ),
                  ReorderableDragStartListener(
                    index: index,
                    child: IconButton(
                      tooltip: 'Arrastar',
                      onPressed: () {},
                      icon: const Icon(Icons.drag_handle),
                    ),
                  ),
                ],
              ),
              onTap: () => _openForm(supplier: supplier),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  Widget _buildFullInventory() {
    if (_suppliers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: _buildEmptyState(),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text(
          'Lista completa dos fornecedores cadastrados',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nome')),
                DataColumn(label: Text('CNPJ ficticio')),
                DataColumn(label: Text('Telefone')),
                DataColumn(label: Text('Descricao')),
                DataColumn(label: Text('Contrato')),
                DataColumn(label: Text('Acoes')),
              ],
              rows: [
                for (final supplier in _suppliers)
                  DataRow(
                    cells: [
                      DataCell(Text(supplier.name)),
                      DataCell(Text(supplier.cnpj)),
                      DataCell(Text(supplier.phone)),
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 280),
                          child: Text(
                            supplier.description,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(Text(_formatDate(supplier.contractDate))),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Editar',
                              onPressed: () => _openForm(supplier: supplier),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              tooltip: 'Remover',
                              onPressed: () => _removeSupplier(supplier),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return selected
        ? FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(icon, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
