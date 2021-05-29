import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/SelectProduct.dart';
import 'package:graduationproject/providers/ProductProvider.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.75,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        // read only to keep keyboard hidden.
        readOnly: true,
        onChanged: (value) => print(value),
        onTap: () async {
          await Provider.of<ProductProvider>(context,listen: false).initiate();
          Navigator.pushNamed(context, SelectProduct.routeName );
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Search product",
            prefixIcon: Icon(Icons.search)),
      ),
    );
  }
}
