// Copyright (c) 2018, codegrue. All rights reserved. Use of this source code
// is governed by the MIT license that can be found in the LICENSE file.

import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';

import '../interfaces/common_field_properties.dart';

const unimplemented = "implement in the wrapper widget";

/// This is the basic layout of a field in a CardSettings view. Typcially, it
/// will not be used directly.
class CardSettingsField extends StatelessWidget
    implements ICommonFieldProperties {
  CardSettingsField({
    this.label: 'Label',
    this.content,
    this.icon,
    this.pickerIcon,
    this.labelWidth,
    this.contentOnNewLine = false,
    this.unitLabel,
    this.errorText,
    this.visible: true,
    this.labelAlign,
    this.requiredIndicator,
    this.enabled = true,
  });

  @override
  final String label;
  final String unitLabel;
  final Widget content;
  final IconData pickerIcon;
  @override
  final double labelWidth;
  final bool contentOnNewLine;
  final String errorText;
  @override
  final bool visible;
  @override
  final TextAlign labelAlign;
  @override
  final Icon icon;
  @override
  final Widget requiredIndicator;
  final bool enabled;

  @override
  TextAlign get contentAlign => throw UnimplementedError(unimplemented);
  @override
  bool get showMaterialonIOS => throw UnimplementedError(unimplemented);
  @override
  bool get autovalidate => throw UnimplementedError(unimplemented);
  @override
  Function get onChanged => throw UnimplementedError(unimplemented);
  @override
  Function get onSaved => throw UnimplementedError(unimplemented);
  @override
  Function get validator => throw UnimplementedError(unimplemented);

  @override
  Widget build(BuildContext context) {
    if (visible) {
      return Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildLabelBlock(context),
                _buildInlineContent(context),
                _buildRightDecoration()
              ],
            ),
            _buildNewRowContent(context)
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildInlineContent(BuildContext context) {
    return contentOnNewLine
        ? Container()
        : Expanded(child: _buildDecoratedContent(context));
  }

  Widget _buildNewRowContent(BuildContext context) {
    if (contentOnNewLine) {
      return Container(
        padding: EdgeInsets.only(top: 10.0),
        child: _buildDecoratedContent(context),
      );
    } else {
      return Container();
    }
  }

  Widget _buildDecoratedContent(BuildContext context) {
    var decoratedContent = content;
    if (content is TextField || content is TextFormField) {
      // do nothing, these already have built in InputDecorations
    } else {
      // wrap in a decorator to show validation errors
      final InputDecoration decoration = const InputDecoration()
          .applyDefaults(Theme.of(context).inputDecorationTheme)
          .copyWith(
              errorText: errorText,
              contentPadding: EdgeInsets.all(0.0),
              isDense: true,
              border: InputBorder.none);

      decoratedContent = InputDecorator(decoration: decoration, child: content);
    }

    return decoratedContent;
  }

  Widget _buildLabelBlock(BuildContext context) {
    var padding =
        EdgeInsets.only(right: CardSettings.of(context).labelPadding ?? 6.0);

    return (contentOnNewLine)
        ? Expanded(
            child: Container(
              padding: padding,
              child: _buildLabelRow(context),
            ),
          )
        : Container(
            width: labelWidth ?? CardSettings.of(context).labelWidth ?? 120.0,
            padding: padding,
            child: _buildLabelRow(context),
          );
  }

  Row _buildLabelRow(BuildContext context) {
    return Row(
      children: <Widget>[
        _buildLeftIcon(context),
        _buildLabelSpacer(context),
        Expanded(
          child: Row(
            children: <Widget>[
              _buildLabelText(context),
              _buildlabelRequiredIndicator(context),
            ],
          ),
        ),
        _buildLabelSuffix(context),
      ],
    );
  }

  Widget _buildLabelText(BuildContext context) {
    // make long label to wrap to the second line
    return Flexible(
      child: Text(
        label,
        softWrap: true,
        style: _buildLabelStyle(context),
      ),
    );
  }

  Widget _buildLabelSpacer(BuildContext context) {
    return ((labelAlign ??
                CardSettings.of(context).labelAlign ??
                TextAlign.left) ==
            TextAlign.right)
        ? Expanded(child: Container())
        : Container();
  }

  Widget _buildLabelSuffix(BuildContext context) {
    return Text(
      (CardSettings.of(context).labelSuffix == null)
          ? ''
          : CardSettings.of(context).labelSuffix,
      style: _buildLabelStyle(context),
    );
  }

  Widget _buildlabelRequiredIndicator(BuildContext context) {
    if (requiredIndicator == null) return Container();

    if (requiredIndicator is Text) {
      var indicatorStyle = (requiredIndicator as Text).style;
      var style = _buildLabelStyle(context).merge(indicatorStyle);

      return Text(
        (requiredIndicator as Text).data,
        style: style,
      );
    }

    return requiredIndicator;
  }

  TextStyle _buildLabelStyle(BuildContext context) {
    TextStyle labelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );

    labelStyle =
        labelStyle.merge(Theme.of(context).inputDecorationTheme.labelStyle);
    if (!enabled)
      labelStyle = labelStyle.copyWith(color: Theme.of(context).disabledColor);

    return labelStyle;
  }

  Widget _buildLeftIcon(BuildContext context) {
    TextStyle labelStyle = Theme.of(context).inputDecorationTheme.labelStyle;

    return (icon == null)
        ? Container()
        : Container(
            margin: EdgeInsets.all(0.0),
            padding: EdgeInsets.only(right: 4.0),
            child: Icon(
              icon.icon,
              color: (icon.color != null)
                  ? icon.color
                  : (labelStyle == null) ? null : labelStyle.color,
            ),
          );
  }

  Widget _buildRightDecoration() {
    return (pickerIcon != null || unitLabel != null)
        ? Container(
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerRight,
            child: (pickerIcon != null)
                ? Icon(pickerIcon, size: 20)
                : Text(
                    unitLabel,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
          )
        : Container();
  }
}
