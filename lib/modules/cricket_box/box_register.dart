import 'dart:io';

import 'package:box_cricket/base_widgets/base_button.dart';
import 'package:box_cricket/base_widgets/base_hero_widget.dart';
import 'package:box_cricket/base_widgets/base_snackbar.dart';
import 'package:box_cricket/constants/validations.dart';
import 'package:box_cricket/modules/cricket_box/box_slots.dart';
import 'package:box_cricket/modules/owner/logic/image_cubit.dart';
import 'package:box_cricket/modules/owner/provider_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../base_widgets/base_text_field.dart';

class BoxRegister extends StatefulWidget {
  const BoxRegister({Key? key}) : super(key: key);

  @override
  _BoxRegisterState createState() => _BoxRegisterState();
}

class _BoxRegisterState extends State<BoxRegister> {
  late ImageCubit _imageCubit;

  late List<XFile> _fileImages;

  late TextEditingController _boxNameController;
  late TextEditingController _boxAddressController;
  late TextEditingController _areaController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _landmarkController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _imageCubit = ImageCubit();
    _fileImages = [];
    _boxNameController = TextEditingController();
    _boxAddressController = TextEditingController();
    _areaController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _landmarkController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _boxNameController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _landmarkController.dispose();
    _imageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: const Center(
                child:
                    Text("Box Registration", style: TextStyle(fontSize: 22))),
          )),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getTextField(
                        validator: Validations().boxNameValidation,
                        labelText: "Box Name",
                        controller: _boxNameController),
                    _getTextField(
                        minLines: 3,
                        maxLines: 5,
                        validator: Validations().boxNameValidation,
                        labelText: "Address",
                        controller: _boxAddressController),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: _getTextField(
                              validator: Validations().zipValidation,
                              controller: _landmarkController,
                              labelText: "Landmark"),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _getTextField(
                                validator: Validations().areaValidation,
                                labelText: "Area",
                                controller: _areaController),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: _getTextField(
                              validator: Validations().cityValidation,
                              controller: _cityController,
                              labelText: "City"),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _getTextField(
                                validator: Validations().stateValidation,
                                labelText: "State",
                                controller: _stateController),
                          ),
                        )
                      ],
                    ),
                    BlocBuilder(
                      bloc: _imageCubit,
                      builder: (context, state) {
                        return _boxImages();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTextField(
      {String? hintText,
      bool? isEnabled,
      Widget? leadingIcon,
      required TextEditingController controller,
      String? Function(String?)? validator,
      TextInputType? keyboardType,
      void Function(String)? onChange,
      String? labelText,
      int? maxLen,
      int? minLines,
      int? maxLines,
      Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BaseTextField(
        controller: controller,
        minLines: minLines,
        maxLen: maxLen,
        maxLines: maxLines,
        onChange: onChange,
        keyboardType: keyboardType,
        labelText: labelText,
        validator: validator,
        isEnabled: isEnabled,
        hintText: hintText,
        prefixIcon: leadingIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _boxImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Upload Box Images (${_fileImages.length}/3):",
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black)),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AddImageWidget(onTap: () {
                    if (_fileImages.length < 3) {
                      _chooseImageFromDialog();
                      // _imageCubit.pickImage();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text(
                          "Cannot upload more than 3 images",
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Theme.of(context).primaryColor,
                      ));
                    }
                  }),
                ),
                BlocConsumer(
                    listener: (context, state) {
                      if (state is ImagePicked) {
                        _fileImages.addAll(state.image ?? <XFile>[]);
                      } else if (state is PickImageFailed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            baseSnackBar(text: state.error ?? ""));
                      }
                    },
                    builder: (BuildContext context, state) {
                      // if (state is ProviderImagePicked) {
                      //   if (state.image != null) {
                      //     _fileImages.addAll(state.image ?? []);
                      //   }
                      return Wrap(
                        children: _fileImages.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                _getImageWidget(e.path, _fileImages.indexOf(e)),
                          );
                        }).toList(),
                      );
                      // }
                      // return const SizedBox();
                    },
                    bloc: _imageCubit),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: BaseButton(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const BoxSlots()));
              },
              text: "Next",
              width: double.infinity),
        ),
      ],
    );
  }

  void _chooseImageFromDialog() {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "From where do you want to upload you image?:",
                            style: TextStyle(fontSize: 18)),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BaseButton(
                              onTap: () {
                                Navigator.pop(dialogContext,false);

                              },
                              text: "Gallery"),
                        ),
                        BaseButton(
                            onTap: () {
                            Navigator.pop(dialogContext,true);
                            },
                            text: "Camera"),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).then((isCamera) {
          if(isCamera == true){
            _imageCubit.cameraImage();
          }else if(isCamera == false){
            _imageCubit.pickImage();
          }
    });
  }

  Widget _getImageWidget(String path, int index) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: BaseHeroWidget(
                        tag: "boxImage",
                        child: Image.file(
                          File(path),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Row(children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _fileImages.removeAt(index);
                              });
                              Navigator.pop(dialogContext);
                            },
                            child: Container(
                              color: Colors.red,
                              child: const Center(
                                child: Text("Remove",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(dialogContext);
                            },
                            child: Container(
                              color: Colors.black,
                              child: const Center(
                                child: Text("Close",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              );
            });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: BaseHeroWidget(
              tag: "boxImage",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Icon(
            Icons.zoom_out_map,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
