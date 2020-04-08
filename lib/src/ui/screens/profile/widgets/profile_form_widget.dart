import 'package:covidapp/src/blocs/profile/profile_form_bloc.dart';
import 'package:covidapp/src/core/custom_localization.dart';
import 'package:covidapp/src/models/profile.dart';
import 'package:covidapp/src/ui/screens/home/home_screen.dart';
import 'package:covidapp/src/ui/screens/profile/widgets/profile_field_widget.dart';
import 'package:covidapp/src/ui/widgets/app_raised_rounded_button/app_raised_rounded_button_widget.dart';
import 'package:covidapp/src/ui/widgets/app_snack_bar/app_sback_bar_widget.dart';
import 'package:covidapp/src/ui/widgets/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';

class ProfileFormWidget extends StatelessWidget {
  final Profile _profile;

  ProfileFormWidget({
    @required Profile profile,
  }) :  _profile = profile;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return FormBlocListener<ProfileFormBloc, String, String>(
          onSubmitting: (context, state) {
            AppSnackBarHandler appSnackBarHandler = AppSnackBarHandler(context);
            appSnackBarHandler.showSnackBar(AppSnackBarWidget.load(
                text: CustomLocalization.of(context).translate('profile_snackbar_loading')
            ));
          },
          onSuccess: (context, state) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return HomeScreen(
                  profile: _profile,
                );
              }),
            );
          },
          onFailure: (context, state) {
            AppSnackBarHandler appSnackBarHandler = AppSnackBarHandler(context);
            appSnackBarHandler.showSnackBar(AppSnackBarWidget.failure(
                text: CustomLocalization.of(context).translate(state.failureResponse),
            ));
          },
          child: _ProfileFormWidget(),
        );
      },
    );
  }
}

class _ProfileFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final ProfileFormBloc profileFormBloc = context.bloc<ProfileFormBloc>();
    final double heightButton = ((MediaQuery.of(context).size.height / 5.0) * 2.0) / 6.0;
    final double widthTextField = MediaQuery.of(context).size.width / 8.0;

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: heightButton, horizontal: widthTextField),
        child: Column(
          children: <Widget>[
            Text(
              CustomLocalization.of(context).translate('profile_label_instruction'),
              style: TextStyle(
                  fontSize: 25.0, height: 1.5, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            ProfileFieldWidget(
              label: CustomLocalization.of(context).translate('profile_label_name'),
              textFieldBloc: profileFormBloc.name,
            ),
            SizedBox(height: 20.0),
            ProfileFieldWidget(
              label: CustomLocalization.of(context).translate('profile_label_age'),
              textFieldBloc: profileFormBloc.age,
              textInputType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            Visibility(
              visible: false,
              child: ProfileFieldWidget(
                label: CustomLocalization.of(context).translate('profile_label_gender'),
                textFieldBloc: profileFormBloc.gender,
              ),
            ),
            _genderPickerWithImage(context: context),
            SizedBox(height: 20.0),
            ProfileFieldWidget(
              label: CustomLocalization.of(context).translate('profile_label_zip'),
              textFieldBloc: profileFormBloc.zip,
              textInputType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            ProfileFieldWidget(
              label: CustomLocalization.of(context).translate('profile_label_state'),
              textFieldBloc: profileFormBloc.ztate,
            ),
            SizedBox(height: 20.0),
            ProfileFieldWidget(
              label: CustomLocalization.of(context).translate('profile_label_town'),
              textFieldBloc: profileFormBloc.town,
            ),
            SizedBox(height: 20.0),
            AppRaisedRoundedButtonWidget(
              height: heightButton,
              width: MediaQuery.of(context).size.width - widthTextField,
              text: CustomLocalization.of(context).translate('profile_button'),
              onPressed: profileFormBloc.submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderPickerWithImage({BuildContext context}) {
    final ProfileFormBloc profileFormBloc = context.bloc<ProfileFormBloc>();

    return GenderPickerWithImage(
      maleText: CustomLocalization.of(context).translate('profile_check_male'),
      femaleText: CustomLocalization.of(context).translate('profile_check_female'),
      verticalAlignedText: true,
      selectedGender: profileFormBloc.gender.value == 'Male' ?
        Gender.Male : profileFormBloc.gender.value == 'Female' ?
        Gender.Female : null,
      selectedGenderTextStyle: TextStyle(
        color: HexColor('FF6345B4'),
        fontWeight: FontWeight.bold,
        fontSize: 25.0,
      ),
      unSelectedGenderTextStyle: TextStyle(
        color: HexColor('FF6345B4'),
        fontWeight: FontWeight.normal,
        fontSize: 25.0,
      ),
      onChanged: (Gender gender) {
        profileFormBloc.gender.updateInitialValue(gender.toString()?.replaceAll("Gender.", ""));
      },
      equallyAligned: true,
      animationDuration: Duration(microseconds: 400),
      opacityOfGradient: 0.2,
      padding: EdgeInsets.fromLTRB(55, 0, 15, 30),
      size: 100,
    );
  }
}




