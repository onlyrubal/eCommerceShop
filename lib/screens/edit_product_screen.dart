import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = '/edit-products';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _checkDidChangeDependenciesRan = true;
  bool _isLoading = false;
  var _editedProduct = Product(
    id: null,
    description: '',
    price: 0,
    title: '',
    imageUrl: '',
  );

  var _initDefaultProductValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_checkDidChangeDependenciesRan) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      // Product details need to be edited.
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initDefaultProductValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageURLController.text = _editedProduct.imageUrl;
      }
    }
    _checkDidChangeDependenciesRan = false;
    super.didChangeDependencies();
  }

  Future<void> _saveProductDetailsForm() async {
    final _isFormValid = _formKey.currentState.validate();

    if (!_isFormValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addNewProduct(_editedProduct);
      } catch (error) {
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured !'),
            content: Text('There is something wrong. Please return later.'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Close'),
              )
            ],
          ),
        );
      } finally {
        setState(
          () {
            _isLoading = false;
          },
        );
        Navigator.of(context).pop();
      }
    }
  }

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) setState(() {});
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product Details',
          style: Theme.of(context).textTheme.headline2,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: new IconThemeData(
          color: Colors.white,
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: TextFormField(
                                    initialValue:
                                        _initDefaultProductValues['title'],
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_priceFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).buttonColor,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).buttonColor,
                                        ),
                                      ),
                                      labelText: 'New Title',
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Title cannot be empty!';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      _editedProduct = Product(
                                        title: newValue,
                                        description: _editedProduct.description,
                                        id: _editedProduct.id,
                                        imageUrl: _editedProduct.imageUrl,
                                        price: _editedProduct.price,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  initialValue:
                                      _initDefaultProductValues['price'],
                                  focusNode: _priceFocusNode,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_descriptionFocusNode);
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).buttonColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                    labelText: 'New Price',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Price cannot be Empty';
                                    if (double.tryParse(value) == null)
                                      return 'Enter valid price value';
                                    if (double.parse(value) < 0)
                                      return 'Price cannot be -ve';
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _editedProduct = Product(
                                      title: _editedProduct.title,
                                      description: _editedProduct.description,
                                      id: _editedProduct.id,
                                      imageUrl: _editedProduct.imageUrl,
                                      price: double.parse(newValue),
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  initialValue:
                                      _initDefaultProductValues['description'],
                                  focusNode: _descriptionFocusNode,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_imageURLFocusNode);
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).buttonColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                    labelText: 'New Description',
                                    helperText: 'Max 250 words.',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Description cannot be Empty!';
                                    if (value.length < 10)
                                      return 'Description should atleast 10 chars long';
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _editedProduct = Product(
                                      title: _editedProduct.title,
                                      description: newValue,
                                      id: _editedProduct.id,
                                      imageUrl: _editedProduct.imageUrl,
                                      price: _editedProduct.price,
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  //initialValue: _initDefaultProductValues['imageUrl'],
                                  focusNode: _imageURLFocusNode,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.url,
                                  controller: _imageURLController,
                                  onFieldSubmitted: (_) {
                                    _saveProductDetailsForm();
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).buttonColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                    labelText: 'Enter Image URL',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'URL cannot be empty';
                                    if (!value.startsWith('http'))
                                      return 'Please enter a valid URL';
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _editedProduct = Product(
                                      title: _editedProduct.title,
                                      description: _editedProduct.description,
                                      id: _editedProduct.id,
                                      imageUrl: newValue,
                                      price: _editedProduct.price,
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: _imageURLController.text.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Image Preview would be shown here',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        )
                                      : FittedBox(
                                          child: Image.network(
                                            _imageURLController.text.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 180,
                                    child: SecondaryButton(btnText: 'Cancel'),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                InkWell(
                                  onTap: _saveProductDetailsForm,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 180,
                                    child: PrimaryButton(btnText: 'Save'),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
