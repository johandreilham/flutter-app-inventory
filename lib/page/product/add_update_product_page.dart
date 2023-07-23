import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/data/source/source_product.dart';

import '../../data/model/product.dart';

class AddUpdateProductPage extends StatefulWidget {
  const AddUpdateProductPage({super.key, this.product});
  final Product? product;

  @override
  State<AddUpdateProductPage> createState() => _AddUpdateProductPageState();
}

class _AddUpdateProductPageState extends State<AddUpdateProductPage> {
  final controllerCode = TextEditingController();
  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();
  final controllerStock = TextEditingController();
  final controllerUnit = TextEditingController();
  final formKey = GlobalKey<FormState>();

  addProduct() async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 'Add Product', 'You sure to add new product?');
    if (yes == true) {
      bool success = await SourceProduct.add(Product(
        code: controllerCode.text,
        name: controllerName.text,
        price: controllerPrice.text,
        stock: int.parse(controllerStock.text),
        unit: controllerUnit.text,
      ));
      if (success) {
        DInfo.dialogSuccess(context, 'Success Add New Product');
        DInfo.closeDialog(context, actionAfterClose: () {
          Get.back(result: true);
        });
      } else {
        DInfo.dialogError(context, 'Failed Add New Product');
        DInfo.closeDialog(context);
      }
    }
  }

  updateProduct() async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 'Update Product', 'You sure to update product?');
    if (yes == true) {
      bool success = await SourceProduct.update(
          widget.product!.code!, // as old code
          Product(
            code: controllerCode.text, // as new code
            name: controllerName.text,
            price: controllerPrice.text,
            stock: int.parse(controllerStock.text),
            unit: controllerUnit.text,
          ));
      if (success) {
        DInfo.dialogSuccess(context, 'Success Update Product');
        DInfo.closeDialog(context, actionAfterClose: () {
          Get.back(result: true);
        });
      } else {
        DInfo.dialogError(context, 'Failed Update Product');
        DInfo.closeDialog(context);
      }
    }
  }

  @override
  void initState() {
    if (widget.product != null) {
      controllerCode.text = widget.product!.code!;
      controllerName.text = widget.product!.name!;
      controllerStock.text = widget.product!.stock.toString();
      controllerUnit.text = widget.product!.unit!;
      controllerPrice.text = widget.product!.price!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft(
          widget.product == null ? 'Add Product' : 'Update Product'),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DInput(
              controller: controllerCode,
              hint: 'ex: 1271HSND',
              title: 'Code',
              validator: (value) => value == '' ? "Don't Empty" : null,
              isRequired: true,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerName,
              hint: 'ex: Name Product',
              title: 'Name',
              validator: (value) => value == '' ? "Don't Empty" : null,
              isRequired: true,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerPrice,
              hint: 'ex: 200000',
              title: 'Price',
              validator: (value) => value == '' ? "Don't Empty" : null,
              isRequired: true,
              inputType: TextInputType.number,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerStock,
              hint: 'ex: 1000',
              title: 'Stock',
              validator: (value) => value == '' ? "Don't Empty" : null,
              isRequired: true,
              inputType: TextInputType.number,
            ),
            DView.spaceHeight(),
            DInput(
              controller: controllerUnit,
              hint: 'ex: Box',
              title: 'Unit',
              validator: (value) => value == '' ? "Don't Empty" : null,
              isRequired: true,
            ),
            DView.spaceHeight(32),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (widget.product == null) {
                    addProduct();
                  } else {
                    updateProduct();
                  }
                }
              },
              child: Text(
                  widget.product == null ? 'Add Product' : 'Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
