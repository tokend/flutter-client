import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/extensions/resources.dart';
import 'package:flutter_template/utils/icons/custom_icons_icons.dart';
import 'package:flutter_template/utils/view/custom_bootom_modal_sheet.dart';
import 'package:image_picker/image_picker.dart';

class AddImageForm extends StatelessWidget {
  final String? imagePath;
  final Function(String) onChanged;

  const AddImageForm({
    Key? key,
    this.imagePath,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    Widget _placeholder = CircleAvatar(
      radius: 38.0,
      child: ClipOval(
        child: Icon(
          CustomIcons.camera_3_fill,
          color: colorTheme.basic,
        ),
      ),
      backgroundColor: colorTheme.suffixIcons,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
            onTap: () => _onAddImage(context),
            child: imagePath == null
                ? _placeholder
                : _ImageWidget(
                    image: imagePath,
                  )),
      ],
    );
  }

  _onAddImage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => CustomModalBottomSheet(
                child: Column(children: [
              GestureDetector(
                  onTap: () {},
                  child: buildListItem(context, title: Text('Select avatars'))),
              GestureDetector(
                  onTap: () => _showGallery(context),
                  child: buildListItem(context,
                      title: Text('Choose from gallery'))),
              GestureDetector(
                onTap: () => _showCamera(context),
                child: buildListItem(
                  context,
                  title: Text('To make a photo'),
                ),
              ),
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Center(
                      child:
                          buildCenterListItem(context, title: Text("Cancel")))),
            ])));
  }

  _showCamera(BuildContext context) {
    Navigator.of(context).pop();
    _showImagePicker(ImageSource.camera);
  }

  _showGallery(BuildContext context) {
    Navigator.of(context).pop();
    _showImagePicker(ImageSource.gallery);
  }

  _showImagePicker(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? image =
        await imagePicker.getImage(source: imageSource, imageQuality: 60);
    if (image != null) {
      onChanged(image.path);
    }
  }
}

class _ImageWidget extends StatelessWidget {
  final String? image;

  const _ImageWidget({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _validURL = image == null ? false : Uri.parse(image!).isAbsolute;
    return Container(
      height: 100,
      width: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: _validURL
            ? Image.network(
                image!,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(image!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
