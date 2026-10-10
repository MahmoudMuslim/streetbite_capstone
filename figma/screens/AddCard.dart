import 'package:flutter/material.dart';
class AddCard extends StatefulWidget {
	const AddCard({super.key});
	@override
	AddCardState createState() => AddCardState();
}
class AddCardState extends State<AddCard> {
	String textField1 = '';
	String textField2 = '';
	String textField3 = '';
	String textField4 = '';
	String textField5 = '';
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Container(
					constraints: const BoxConstraints.expand(),
					color: Color(0xFFFFFFFF),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: IntrinsicHeight(
									child: Container(
										color: Color(0xFFFFFFFF),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	Container(
																		margin: const EdgeInsets.only( left: 47),
																		child: Text(
																			"9:41",
																			style: TextStyle(
																				color: Color(0xFF1C1B1F),
																				fontSize: 17,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																	Container(
																		width: 134,
																		height: 54,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/iq9h9re4_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/3i64c0qz_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 20, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 8),
																		child: Text(
																			"Add card",
																			style: TextStyle(
																				color: Color(0xFF1C1B1F),
																				fontSize: 28,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( left: 20, right: 20),
															margin: const EdgeInsets.only( bottom: 343),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			alignment: Alignment.center,
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(12),
																				color: Color(0xFFF7F7F7),
																			),
																			margin: const EdgeInsets.only( bottom: 12),
																			width: double.infinity,
																			child: TextField(
																				style: TextStyle(
																					color: Color(0xFFA09CAB),
																					fontSize: 16,
																				),
																				onChanged: (value) { 
																					setState(() { textField1 = value; });
																				},
																				decoration: InputDecoration(
																					hintText: "Card number",
																					isDense: true,
																					contentPadding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
																					border: InputBorder.none,
																					focusedBorder: InputBorder.none,
																					filled: false,
																				),
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			alignment: Alignment.center,
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(12),
																				color: Color(0xFFF7F7F7),
																			),
																			margin: const EdgeInsets.only( bottom: 12),
																			width: double.infinity,
																			child: TextField(
																				style: TextStyle(
																					color: Color(0xFFA09CAB),
																					fontSize: 16,
																				),
																				onChanged: (value) { 
																					setState(() { textField2 = value; });
																				},
																				decoration: InputDecoration(
																					hintText: "Name",
																					isDense: true,
																					contentPadding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
																					border: InputBorder.none,
																					focusedBorder: InputBorder.none,
																					filled: false,
																				),
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 12),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								alignment: Alignment.center,
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(12),
																									color: Color(0xFFF7F7F7),
																								),
																								margin: const EdgeInsets.only( right: 9),
																								width: double.infinity,
																								child: TextField(
																									style: TextStyle(
																										color: Color(0xFFA09CAB),
																										fontSize: 16,
																									),
																									onChanged: (value) { 
																										setState(() { textField3 = value; });
																									},
																									decoration: InputDecoration(
																										hintText: "Exp",
																										isDense: true,
																										contentPadding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
																										border: InputBorder.none,
																										focusedBorder: InputBorder.none,
																										filled: false,
																									),
																								),
																							),
																						),
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								alignment: Alignment.center,
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(12),
																									color: Color(0xFFF7F7F7),
																								),
																								margin: const EdgeInsets.only( right: 8),
																								width: double.infinity,
																								child: TextField(
																									style: TextStyle(
																										color: Color(0xFFA09CAB),
																										fontSize: 16,
																									),
																									onChanged: (value) { 
																										setState(() { textField4 = value; });
																									},
																									decoration: InputDecoration(
																										hintText: "CVV",
																										isDense: true,
																										contentPadding: const EdgeInsets.only( top: 12, bottom: 12, left: 15, right: 15),
																										border: InputBorder.none,
																										focusedBorder: InputBorder.none,
																										filled: false,
																									),
																								),
																							),
																						),
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								alignment: Alignment.center,
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(12),
																									color: Color(0xFFF7F7F7),
																								),
																								width: double.infinity,
																								child: TextField(
																									style: TextStyle(
																										color: Color(0xFFA09CAB),
																										fontSize: 16,
																									),
																									onChanged: (value) { 
																										setState(() { textField5 = value; });
																									},
																									decoration: InputDecoration(
																										hintText: "Zip",
																										isDense: true,
																										contentPadding: const EdgeInsets.only( top: 12, bottom: 12, left: 15, right: 15),
																										border: InputBorder.none,
																										focusedBorder: InputBorder.none,
																										filled: false,
																									),
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			color: Color(0xFFFFFFFF),
																			padding: const EdgeInsets.symmetric(vertical: 8),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( right: 8),
																						width: 24,
																						height: 24,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/aku0ghzt_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					Text(
																						"Default payment method",
																						style: TextStyle(
																							color: Color(0xFF1C1B1F),
																							fontSize: 16,
																							fontWeight: FontWeight.bold,
																						),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 14, bottom: 14, left: 16, right: 16),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	InkWell(
																		onTap: () { print('Pressed'); },
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(28),
																					color: Color(0xFF00C773),
																				),
																				padding: const EdgeInsets.symmetric(vertical: 14),
																				width: double.infinity,
																				child: Column(
																					children: [
																						Text(
																							"Continue",
																							style: TextStyle(
																								color: Color(0xFFFFFFFF),
																								fontSize: 16,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.symmetric(vertical: 8),
															width: double.infinity,
															child: Column(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(100),
																			color: Color(0xFF1C1B1F),
																		),
																		width: 139,
																		height: 5,
																		child: SizedBox(),
																	),
																]
															),
														),
													),
												],
											)
										),
									),
								),
							),
						],
					),
				),
			),
		);
	}
}