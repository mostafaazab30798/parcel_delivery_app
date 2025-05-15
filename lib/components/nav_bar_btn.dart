import 'package:flutter/material.dart';

class NavBarBtn extends StatelessWidget {
  const NavBarBtn({super.key, required this.icon, required this.name});
  final Image icon;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: InkWell(
            onTap: () {},
            child: icon,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            name,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: 16,
                  color: Theme.of(context).hintColor,
                ),
          ),
        )
      ],
    );
  }
}
