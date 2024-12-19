import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/thorax_evaluation_strategy.dart';

class RotemScreen extends StatefulWidget {
  @override
  _RotemScreenState createState() => _RotemScreenState();
}

class _RotemScreenState extends State<RotemScreen> {
  final _formKey = GlobalKey<FormState>();

  final _ctExtemController = TextEditingController();
  final _ctIntemController = TextEditingController();
  final _a10FibtemController = TextEditingController();
  final _a5FibtemController = TextEditingController();
  final _a10ExtemController = TextEditingController();
  final _a5ExtemController = TextEditingController();
  final _mlExtemController = TextEditingController();
  final _ctHeptemController = TextEditingController();

  // Declare FocusNodes
  final _ctExtemFocusNode = FocusNode();
  final _ctIntemFocusNode = FocusNode();
  final _a10FibtemFocusNode = FocusNode();
  final _a5FibtemFocusNode = FocusNode();
  final _a10ExtemFocusNode = FocusNode();
  final _a5ExtemFocusNode = FocusNode();
  final _mlExtemFocusNode = FocusNode();
  final _ctHeptemFocusNode = FocusNode();

  String? _errorText;

  Map<String, String> _actions = {};

  void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Validation Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    ),
  );
}

void _clearFields() {
  setState(() {
  _ctExtemController.clear();
  _ctIntemController.clear();
  _a10FibtemController.clear();
  _a5FibtemController.clear();
  _a10ExtemController.clear();
  _a5ExtemController.clear();
  _mlExtemController.clear();
  _ctHeptemController.clear();
  });
}

  


  void _evaluate() {
    if (_formKey.currentState!.validate()) {
    if (!_validateFibtemFields()) {
      setState (() {
        _errorText = 'Antingen A5 FIBTEM eller A10 FIBTEM måste fyllas i.';
      });
      return;
    }
    if (!_validateExtemFields()) {
      setState (() {
        _errorText = 'Antingen A5 EXTEM eller A10 EXTEM måste fyllas i.';
      });
      return;
    }
     
      final evaluator = RotemEvaluator(
        ctExtem: _checkDouble(_ctExtemController.text),
        ctIntem: _checkDouble(_ctIntemController.text),
        a10Fibtem: _checkDouble(_a10FibtemController.text),
        a5Fibtem: _checkDouble(_a5FibtemController.text),
        a10Extem: _checkDouble(_a10ExtemController.text),
        a5Extem: _checkDouble(_a5ExtemController.text),
        mlExtem: _checkDouble(_mlExtemController.text),
        ctHeptem: _checkDouble(_ctHeptemController.text),
        strategy: TraumaEvaluationStrategy(),
      );

      setState(() {
        _errorText = null;
        _actions = evaluator.evaluate();
      });
      showResultDialog();

    }
  }
  showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resultat'),
        content: Column(
          children: [
            if (_actions.isNotEmpty)
              ..._actions.entries.map(
                (action) => Text(
                  '${action.value} : Ge ${action.key}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  double? _checkDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }

  bool _validateFibtemFields() {
    return _a5FibtemController.text.isNotEmpty ||
        _a10FibtemController.text.isNotEmpty;
  }

  bool _validateExtemFields() {
    return _a5ExtemController.text.isNotEmpty ||
        _a10ExtemController.text.isNotEmpty;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value) != null ? null : 'Enter a valid number';
  }
  @override
  void dispose() {
    // Dispose of controllers
    _ctExtemController.dispose();
    _ctIntemController.dispose();
    _a10FibtemController.dispose();
    _a5FibtemController.dispose();
    _a10ExtemController.dispose();
    _a5ExtemController.dispose();
    _mlExtemController.dispose();
    _ctHeptemController.dispose();

    // Dispose of focus nodes
    _ctExtemFocusNode.dispose();
    _ctIntemFocusNode.dispose();
    _a10FibtemFocusNode.dispose();
    _a5FibtemFocusNode.dispose();
    _a10ExtemFocusNode.dispose();
    _a5ExtemFocusNode.dispose();
    _mlExtemFocusNode.dispose();
    _ctHeptemFocusNode.dispose();

    super.dispose();
  }
Widget entry(String label, TextEditingController controller, FocusNode currentFocus, FocusNode? nextFocus) {
  return SizedBox(
    width: 100,
    child: TextFormField(
      controller: controller,
      focusNode: currentFocus,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: OutlineInputBorder(gapPadding: 2),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
      onEditingComplete: () {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      validator: _numberValidator,
    ),
  );
}
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Tolkare ROTEM'),
      actions: [
        TextButton.icon(onPressed: _clearFields, label: Text('Rensa'), icon: Icon(Icons.clear)  
     
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          
                 Text(
                'FIBTEM',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   entry("A5 FIBTEM", _a5FibtemController, _a5FibtemFocusNode, _a10FibtemFocusNode),
                        SizedBox(width: 10),
                  entry("A10 FIBTEM", _a10FibtemController, _a10FibtemFocusNode, _ctIntemFocusNode)
             
                 
                ],
              ),
              SizedBox(height: 10),// INTEM Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'INTEM',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
         
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 100, child: entry("CT INTEM", _ctIntemController, _ctIntemFocusNode, _a5ExtemFocusNode)),
                ],
              ),
              
            
              SizedBox(height: 10),
      
              // EXTEM Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'EXTEM',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  entry("A5 EXTEM", _a5ExtemController, _a5ExtemFocusNode, _a10ExtemFocusNode),
                  SizedBox(width: 10),
                  entry("A10 EXTEM", _a10ExtemController, _a10ExtemFocusNode, _ctExtemFocusNode),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  entry("CT EXTEM", _ctExtemController, _ctExtemFocusNode, _mlExtemFocusNode),
                  SizedBox(width: 10),
                 entry("ML EXTEM", _mlExtemController, _mlExtemFocusNode, _ctHeptemFocusNode),
                ],
              ),
              SizedBox(height: 10),
      
              // FIBTEM Section
           
      
              // HEPTEM Section
              Text(
                'HEPTEM',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  entry("CT HEPTEM", _ctHeptemController, _ctHeptemFocusNode, null),
                ],
              ),
              SizedBox(height: 20),
         if (_errorText != null)
                Text(
                  _errorText!,
                  style: TextStyle(color: Colors.red),
                ),
              // Evaluate Button
         
       
                  ElevatedButton(
                    onPressed: _evaluate,
                    child: Text('Visa förslag'),
             
              ),
              SizedBox(height: 16),
              if (_actions.isNotEmpty)
                ..._actions.entries.map(
                  (action) => Text(
                    '${action.key}: ${action.value}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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