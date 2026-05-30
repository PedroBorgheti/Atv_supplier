import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:atv_supplier/main.dart';

void main() {
  testWidgets('abre a tela inicial de fornecedores', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SupplierApp());
    await tester.pump();

    expect(find.text('Sistema Supplier'), findsOneWidget);

    await tester.enterText(find.byType(EditableText).at(0), 'teste');
    await tester.enterText(find.byType(EditableText).at(1), 'teste');
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Fornecedores'), findsWidgets);
    expect(find.text('Nenhum fornecedor cadastrado'), findsOneWidget);
    expect(find.text('Fornecedor'), findsOneWidget);
  });
}
