import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';

import '../provider/product.dart';

class EditProductScreen extends StatefulWidget {
  static final route = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgController = TextEditingController();
  final _imgFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String _title = '', _des = ' ', _imgUrl = '';
  double _price = 0.0;
  Product _editedProduct = Product(
      id: '',
      title: '',
      description: '',
      price: 0.0,
      imageUrl: 'imageUrl',
      isFavorites: false);
  bool isDepCalled = true;

  @override
  void initState() {
    _imgFocusNode.addListener((_updateImgUrl));

    super.initState();
  }

  void _updateImgUrl() {
    if (!_imgController.text.startsWith('http') &&
        !_imgController.text.startsWith('https')) return;
    if (!_imgFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (isDepCalled) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _imgController.text = _editedProduct.imageUrl;
      }
    }
    isDepCalled = false;
  }

  var _isLoading = false;

  Future<void> _saveForm() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();
    _editedProduct = Product(
        id: _editedProduct.id,
        title: _title,
        description: _des,
        price: _price,
        imageUrl: _imgUrl,
        isFavorites: _editedProduct.isFavorites);

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id.isEmpty) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An Error occured!'),
                  content: Text('Something went wrong.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An Error occured!'),
                  content: Text('Something went wrong.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      }
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();

    _imgFocusNode.removeListener((_updateImgUrl));
    _imgFocusNode.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _editedProduct.title,
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _title = value.toString();
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) return 'Enter a title';
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _editedProduct.price.toString(),
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        onSaved: (value) {
                          _price = double.parse(value.toString());
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) return 'Enter a Price.';
                          if (double.parse(value.toString()) < 0)
                            return 'Enter a value greaten than 0!';
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _editedProduct.description,
                        decoration: InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descFocusNode,
                        onSaved: (value) {
                          _des = value.toString();
                        },
                        validator: (value) {
                          if (value.toString().isEmpty)
                            return 'Enter a Description';
                          if (value.toString().length < 10)
                            return 'Enter a Description of atleast 10 charachte.';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imgController.text.isEmpty
                                ? Text('Enter Url')
                                : FittedBox(
                                    child: Image.network(
                                      _imgController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Enter Img Url'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imgController,
                            focusNode: _imgFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onSaved: (value) {
                              _imgUrl = value.toString();
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) {
                              if (value.toString().isEmpty)
                                return 'Enter a Image Url';
                              if (!value.toString().startsWith('http') &&
                                  !value.toString().startsWith('https'))
                                return 'Enter a valid url.';
                              return null;
                            },
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(onPressed: _saveForm, child: Text('Save'))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
