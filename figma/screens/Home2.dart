import 'package:flutter/material.dart';
class Home2 extends StatefulWidget {
	const Home2({super.key});
	@override
	Home2State createState() => Home2State();
}
class Home2State extends State<Home2> {
	String textField1 = '';
	String textField2 = '';
	String textField3 = '';
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/xfdfsrh5_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/ifc487si_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 28, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 16),
																		child: Text(
																			"Delivery address ",
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
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( left: 20, right: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.symmetric(vertical: 116),
																			width: double.infinity,
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(12),
																				image: DecorationImage(
																					image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/g4p1zz8q_expires_30_days.png"),
																					fit: BoxFit.fill
																				),
																			),
																			child: Column(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( bottom: 8),
																						width: 40,
																						height: 48,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/hcd433de_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					InkWell(
																						onTap: () { print('Pressed'); },
																						child: IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										borderRadius: BorderRadius.circular(32),
																										color: Color(0xFFFFFFFF),
																										boxShadow: [
																											BoxShadow(
																												color: Color(0x26000000),
																												blurRadius: 8,
																												offset: Offset(0, 4),
																											),
																										],
																									),
																									padding: const EdgeInsets.only( top: 4, bottom: 4, left: 12, right: 12),
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Text(
																												"Adjust pin",
																												style: TextStyle(
																													color: Color(0xFF1C1B1F),
																													fontSize: 14,
																													fontWeight: FontWeight.bold,
																												),
																											),
																										]
																									),
																								),
																							),
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
															padding: const EdgeInsets.all(20),
															margin: const EdgeInsets.only( bottom: 4),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 16),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( bottom: 4),
																						child: Text(
																							"Address ",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
																								fontSize: 14,
																								fontWeight: FontWeight.bold,
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
																							width: double.infinity,
																							child: TextField(
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																								),
																								onChanged: (value) { 
																									setState(() { textField1 = value; });
																								},
																								decoration: InputDecoration(
																									hintText: "Park Way 145",
																									isDense: true,
																									contentPadding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
																									border: InputBorder.none,
																									focusedBorder: InputBorder.none,
																									filled: false,
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
																			margin: const EdgeInsets.only( bottom: 16),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( bottom: 4),
																						child: Text(
																							"Apartment",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
																								fontSize: 14,
																								fontWeight: FontWeight.bold,
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
																							width: double.infinity,
																							child: TextField(
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																								),
																								onChanged: (value) { 
																									setState(() { textField2 = value; });
																								},
																								decoration: InputDecoration(
																									hintText: "14",
																									isDense: true,
																									contentPadding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
																									border: InputBorder.none,
																									focusedBorder: InputBorder.none,
																									filled: false,
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
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( bottom: 4),
																						child: Text(
																							"Comment",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
																								fontSize: 14,
																								fontWeight: FontWeight.bold,
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
																							width: double.infinity,
																							child: TextField(
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																								),
																								onChanged: (value) { 
																									setState(() { textField3 = value; });
																								},
																								decoration: InputDecoration(
																									hintText: "Leave near the entrence",
																									isDense: true,
																									contentPadding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
																									border: InputBorder.none,
																									focusedBorder: InputBorder.none,
																									filled: false,
																								),
																							),
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