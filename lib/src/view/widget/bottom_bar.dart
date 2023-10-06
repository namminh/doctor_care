import 'package:flutter/material.dart';
import 'package:test_agora/core/app_style.dart';

class BottomBar extends StatelessWidget {
  final VoidCallback? onTap1;
  final VoidCallback? onTap2;
  final String priceLabel;
  final String status;
  final String priceValue;
  final String buttonLabel1;
  final String buttonLabel2;

  const BottomBar(
      {Key? key,
      this.onTap1,
      this.onTap2,
      this.priceLabel = "Price",
      this.status = "OK",
      required this.priceValue,
      this.buttonLabel1 = "Add to cart",
      this.buttonLabel2 = "Add to cart"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                  priceLabel,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              FittedBox(child: Text(priceValue, style: h2Style)),
              const SizedBox(height: 5),
              FittedBox(
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onTap1,
                  child: Text(buttonLabel1),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ElevatedButton(
                  onPressed: onTap2,
                  child: Text(buttonLabel2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
