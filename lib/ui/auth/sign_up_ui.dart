import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:flutter_starter/helpers/helpers.dart';
import 'package:flutter_starter/controllers/controllers.dart';
import 'package:flutter_starter/ui/auth/auth.dart';
import 'package:image_picker/image_picker.dart';

class SignUpUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _headerImage(context),
                  SizedBox(height: 48.0),
                  FormInputFieldWithIcon(
                    controller: authController.nameController,
                    iconPrefix: Icons.person,
                    labelText: 'auth.nameFormField'.tr,
                    validator: Validator().name,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.nameController.text = value!,
                  ),
                  FormVerticalSpace(),
                  FormInputFieldWithIcon(
                    controller: authController.emailController,
                    iconPrefix: Icons.email,
                    labelText: 'auth.emailFormField'.tr,
                    validator: Validator().email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.emailController.text = value!,
                  ),
                  FormVerticalSpace(),
                  FormInputFieldWithIcon(
                    controller: authController.passwordController,
                    iconPrefix: Icons.lock,
                    labelText: 'auth.passwordFormField'.tr,
                    validator: Validator().password,
                    obscureText: true,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.passwordController.text = value!,
                    maxLines: 1,
                  ),
                  FormVerticalSpace(),
                  PrimaryButton(
                      labelText: 'auth.signUpButton'.tr,
                      onPressed: authController.url.value == ""
                          ? () {
                              Get.snackbar("Error", "Please Select Any Image",
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.red,
                                  colorText:
                                      Get.theme.snackBarTheme.actionTextColor);
                            }
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                SystemChannels.textInput.invokeMethod(
                                    'TextInput.hide'); //to hide the keyboard - if any
                                authController
                                    .registerWithEmailAndPassword(context);
                              }
                            }),
                  FormVerticalSpace(),
                  LabelButton(
                    labelText: 'auth.signInLabelButton'.tr,
                    onPressed: () => Get.to(SignInUI()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        authController.getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      authController.getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _headerImage(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                Obx(
                  () => CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white70,
                      child: authController.selectedImagePath.value != ''
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(
                                File((authController.selectedImagePath.value)),
                              ))
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage("assets/images/person.png"),
                            )),
                ),
                Positioned(
                  top: 65,
                  left: 45,
                  child: RawMaterialButton(
                    elevation: 10,
                    fillColor: Colors.pink,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 15,
                    ),
                    padding: EdgeInsets.all(10),
                    shape: CircleBorder(),
                    onPressed: () {
                      _showPicker(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
