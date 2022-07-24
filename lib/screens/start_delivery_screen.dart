// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:signature/signature.dart';
// import '../app_config.dart';
// import '../bloc/nova_bloc.dart';
// import '../models/nova_model.dart';

// class StartPickupScreen extends StatefulWidget {
//   final String pickupId;
//   const StartPickupScreen({Key? key, required this.pickupId}) : super(key: key);

//   @override
//   State<StartPickupScreen> createState() => _StartPickupScreenState();
// }

// class _StartPickupScreenState extends State<StartPickupScreen> {
//   NovaBloc novaBloc = NovaBloc();
//   final List<Uint8List> _proofImages = [];
//   Uint8List? _signature;
//   final SignatureController _signatureController = SignatureController(
//     penStrokeWidth: 3,
//     penColor: Colors.black,
//     exportBackgroundColor: Colors.white,
//   );
//   bool productsChecked = false;
//   bool gotproofImages = false;

//   bool gotSignature = false;

//   @override
//   void initState() {
//     super.initState();

//     novaBloc.add(GetPickupDetailEvent(id: widget.pickupId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.black),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text("Confirmation"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 10, right: 10),
//         child: StreamBuilder<PickupDetailResponseModel>(
//             stream: novaBloc.outPickupDetailResponse,
//             builder: (context, outPickupDetailResponseSnapshot) {
//               if (outPickupDetailResponseSnapshot.data != null) {
//                 return Stack(
//                   children: [
//                     Column(children: [
//                       StreamBuilder<bool>(
//                           initialData: false,
//                           stream: novaBloc.outStartPickupProductsConfirmed,
//                           builder: (context,
//                               outStartPickupProductsConfirmedSnapshot) {
//                             return InkWell(
//                               onTap: (() => _confirmationDialogForProducts()),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(color: pale),
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 10, right: 10, top: 10, bottom: 10),
//                                   child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               PhosphorIcons.check_circle,
//                                               color:
//                                                   outStartPickupProductsConfirmedSnapshot
//                                                           .data!
//                                                       ? link
//                                                       : gray,
//                                             ),
//                                             const Padding(
//                                               padding:
//                                                   EdgeInsets.only(left: 10),
//                                               child: Text("Products"),
//                                             ),
//                                           ],
//                                         ),
//                                         const Icon(PhosphorIcons.caret_right)
//                                       ]),
//                                 ),
//                               ),
//                             );
//                           }),
//                       StreamBuilder<List<Uint8List>>(
//                           stream: novaBloc.outStartPickupProofImages,
//                           builder:
//                               (context, outStartPickupProofImagesSnapshot) {
//                             return InkWell(
//                               onTap: (() =>
//                                   outStartPickupProofImagesSnapshot.data == null
//                                       ? getProofImage()
//                                       : null),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(color: pale),
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 10, right: 10, top: 10, bottom: 10),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Icon(
//                                                   PhosphorIcons.check_circle,
//                                                   color:
//                                                       outStartPickupProofImagesSnapshot
//                                                                   .data !=
//                                                               null
//                                                           ? link
//                                                           : gray,
//                                                 ),
//                                                 const Padding(
//                                                   padding:
//                                                       EdgeInsets.only(left: 10),
//                                                   child:
//                                                       Text("Proof of pickup"),
//                                                 ),
//                                               ],
//                                             ),
//                                             outStartPickupProofImagesSnapshot
//                                                         .data !=
//                                                     null
//                                                 ? Container()
//                                                 : const Icon(
//                                                     PhosphorIcons.caret_right)
//                                           ]),
//                                       outStartPickupProofImagesSnapshot.data !=
//                                               null
//                                           ? SingleChildScrollView(
//                                               scrollDirection: Axis.horizontal,
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 10),
//                                                 child: Row(
//                                                   children: [
//                                                     Row(
//                                                       children: List.generate(
//                                                           outStartPickupProofImagesSnapshot
//                                                               .data!.length,
//                                                           (proofImagesIndex) {
//                                                         return Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .only(
//                                                                   right: 15),
//                                                           child: Stack(
//                                                             children: [
//                                                               ClipRRect(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             5),
//                                                                 child: Image
//                                                                     .memory(
//                                                                   outStartPickupProofImagesSnapshot
//                                                                           .data![
//                                                                       proofImagesIndex],
//                                                                   height: 50,
//                                                                   width: 50,
//                                                                   fit: BoxFit
//                                                                       .fill,
//                                                                 ),
//                                                               ),
//                                                               IconButton(
//                                                                   onPressed:
//                                                                       () {
//                                                                     _proofImages
//                                                                         .removeAt(
//                                                                             proofImagesIndex);
//                                                                     novaBloc
//                                                                         .inStartPickupProofImages
//                                                                         .add(
//                                                                             _proofImages);
//                                                                   },
//                                                                   icon:
//                                                                       const Icon(
//                                                                     PhosphorIcons
//                                                                         .x_circle_fill,
//                                                                     color: Colors
//                                                                         .white,
//                                                                   ))
//                                                             ],
//                                                           ),
//                                                         );
//                                                       }),
//                                                     ),
//                                                     IconButton(
//                                                         onPressed: () {
//                                                           getProofImage();
//                                                         },
//                                                         icon: const Icon(
//                                                           PhosphorIcons.plus,
//                                                           color: link,
//                                                         ))
//                                                   ],
//                                                 ),
//                                               ),
//                                             )
//                                           : Container()
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }),
//                       StreamBuilder<Uint8List>(
//                           stream: novaBloc.outStartPickupSignature,
//                           builder: (context, outStartPickupSignatureSnapshot) {
//                             return InkWell(
//                               onTap: (() =>
//                                   outStartPickupSignatureSnapshot.data != null
//                                       ? null
//                                       : _confirmationDialogForSignature(
//                                           outPickupDetailResponseSnapshot.data!
//                                               .application![0].farmer!.name)),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(color: pale),
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 10, right: 10, top: 10, bottom: 10),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Icon(
//                                                   PhosphorIcons.check_circle,
//                                                   color:
//                                                       outStartPickupSignatureSnapshot
//                                                                   .data !=
//                                                               null
//                                                           ? link
//                                                           : gray,
//                                                 ),
//                                                 const Padding(
//                                                   padding:
//                                                       EdgeInsets.only(left: 10),
//                                                   child: Text("Signature"),
//                                                 ),
//                                               ],
//                                             ),
//                                             const Icon(
//                                                 PhosphorIcons.caret_right)
//                                           ]),
//                                       outStartPickupSignatureSnapshot.data !=
//                                               null
//                                           ? ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                               child: Image.memory(
//                                                 outStartPickupSignatureSnapshot
//                                                     .data!,
//                                                 height: 100,
//                                                 width: 100,
//                                                 fit: BoxFit.fill,
//                                               ),
//                                             )
//                                           : Container()
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }),
//                     ]),
//                     Align(
//                         alignment: Alignment.bottomCenter,
//                         child: MaterialButton(
//                             minWidth: MediaQuery.of(context).size.width,
//                             color: secondary,
//                             child: StreamBuilder<bool>(
//                                 initialData: false,
//                                 stream: novaBloc.outIsProcessing,
//                                 builder: (context, outIsProcessingSnapshot) {
//                                   return outIsProcessingSnapshot.data!
//                                       ? const LinearProgressIndicator(
//                                           backgroundColor: Colors.white,
//                                           color: primary,
//                                         )
//                                       : const Padding(
//                                           padding: EdgeInsets.only(
//                                               top: 15, bottom: 15),
//                                           child: Text(
//                                             "Finish",
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w700),
//                                           ),
//                                         );
//                                 }),
//                             onPressed: () {
//                               if (productsChecked &&
//                                   gotproofImages &&
//                                   gotSignature) {
//                                 novaBloc.inIsProcessing.add(true);
//                                 novaBloc.add(StartPickupEvent(
//                                     products: outPickupDetailResponseSnapshot
//                                         .data!.application![0].products,
//                                     applicationId: widget.pickupId,
//                                     context: context,
//                                     proofImages: _proofImages,
//                                     signature: _signature));
//                               }
//                             }))
//                   ],
//                 );
//               } else {
//                 return Container();
//               }
//             }),
//       ),
//     );
//   }

//   _confirmationDialogForProducts() {
//     showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black12.withOpacity(0.6), // Background color
//       barrierDismissible: false,
//       barrierLabel: 'Dialog',
//       transitionDuration: const Duration(milliseconds: 400),
//       pageBuilder: (_, __, ___) {
//         return Scaffold(
//             appBar: AppBar(
//               iconTheme: const IconThemeData(color: Colors.black),
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               title: const Text("Products"),
//             ),
//             body: Padding(
//               padding: const EdgeInsets.only(
//                   left: 15, right: 15, top: 15, bottom: 15),
//               child: StreamBuilder<PickupDetailResponseModel>(
//                   stream: novaBloc.outPickupDetailResponse,
//                   builder: (context, outPickupDetailResponseSnapshot) {
//                     if (outPickupDetailResponseSnapshot.data != null) {
//                       num total = 0;
//                       for (var element in outPickupDetailResponseSnapshot
//                           .data!.application![0].products!) {
//                         total = total +
//                             element.adminQuantity! *
//                                 element.adminEstimatedPrice!;
//                       }
//                       return StreamBuilder<List<num>>(
//                           initialData: const [],
//                           stream: novaBloc.outDeletedProductsIndexList,
//                           builder:
//                               (context, outDeletedProductsIndexListSnapshot) {
//                             return Stack(
//                               children: [
//                                 Column(
//                                   children: List.generate(
//                                       outPickupDetailResponseSnapshot
//                                           .data!
//                                           .application![0]
//                                           .products!
//                                           .length, (productsIndex) {
//                                     return Padding(
//                                       padding: const EdgeInsets.only(top: 10),
//                                       child: Container(
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         decoration: BoxDecoration(
//                                             border: Border.all(color: pale),
//                                             borderRadius:
//                                                 BorderRadius.circular(5)),
//                                         child: Stack(
//                                           children: [
//                                             Container(
//                                               decoration: BoxDecoration(
//                                                   border:
//                                                       Border.all(color: pale),
//                                                   color:
//                                                       outDeletedProductsIndexListSnapshot
//                                                               .data!
//                                                               .contains(
//                                                                   productsIndex)
//                                                           ? darkGray
//                                                               .withOpacity(0.4)
//                                                           : Colors.transparent,
//                                                   borderRadius:
//                                                       BorderRadius.circular(5)),
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 10,
//                                                     bottom: 10,
//                                                     left: 10,
//                                                     right: 10),
//                                                 child: IgnorePointer(
//                                                   ignoring:
//                                                       outDeletedProductsIndexListSnapshot
//                                                               .data!
//                                                               .contains(
//                                                                   productsIndex)
//                                                           ? true
//                                                           : false,
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           Image.network(
//                                                               outPickupDetailResponseSnapshot
//                                                                   .data!
//                                                                   .application![
//                                                                       0]
//                                                                   .products![
//                                                                       productsIndex]
//                                                                   .images![0]
//                                                                   .imageUrl!,
//                                                               height: 50,
//                                                               width: 50),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     left: 10),
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   outPickupDetailResponseSnapshot
//                                                                       .data!
//                                                                       .application![
//                                                                           0]
//                                                                       .products![
//                                                                           productsIndex]
//                                                                       .productName!,
//                                                                   style:
//                                                                       const TextStyle(
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700,
//                                                                   ),
//                                                                 ),
//                                                                 Padding(
//                                                                   padding: const EdgeInsets
//                                                                           .only(
//                                                                       top: 15,
//                                                                       bottom:
//                                                                           15),
//                                                                   child: Text(
//                                                                     "Rs. ${outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminEstimatedPrice!}/${outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminQuantityUnit!}",
//                                                                     style:
//                                                                         const TextStyle(
//                                                                       color:
//                                                                           primary,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w700,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 Row(
//                                                                   children: [
//                                                                     const Text(
//                                                                       "Qty:",
//                                                                       style:
//                                                                           TextStyle(
//                                                                         fontWeight:
//                                                                             FontWeight.w400,
//                                                                       ),
//                                                                     ),
//                                                                     Padding(
//                                                                       padding: const EdgeInsets
//                                                                               .only(
//                                                                           right:
//                                                                               5,
//                                                                           left:
//                                                                               5),
//                                                                       child:
//                                                                           Container(
//                                                                         height:
//                                                                             30,
//                                                                         decoration: BoxDecoration(
//                                                                             border:
//                                                                                 Border.all(color: pale),
//                                                                             borderRadius: BorderRadius.circular(5)),
//                                                                         child:
//                                                                             Row(
//                                                                           children: [
//                                                                             Padding(
//                                                                               padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
//                                                                               child: InkWell(
//                                                                                 onTap: () {
//                                                                                   if (outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminQuantity != 1) {
//                                                                                     outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminQuantity = outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminQuantity! - 1;
//                                                                                     novaBloc.inPickupDetailResponse.add(outPickupDetailResponseSnapshot.data!);
//                                                                                   }
//                                                                                 },
//                                                                                 child: const Icon(
//                                                                                   PhosphorIcons.minus,
//                                                                                   color: link,
//                                                                                   size: 15,
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                             const VerticalDivider(
//                                                                               thickness: 2,
//                                                                             ),
//                                                                             Padding(
//                                                                               padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
//                                                                               child: Text(
//                                                                                 "${outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminQuantity!}",
//                                                                               ),
//                                                                             ),
//                                                                             const VerticalDivider(
//                                                                               thickness: 2,
//                                                                             ),
//                                                                             Padding(
//                                                                               padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
//                                                                               child: InkWell(
//                                                                                 onTap: () {
//                                                                                   outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminQuantity = outPickupDetailResponseSnapshot.data!.application![0].products![productsIndex].adminQuantity! + 1;

//                                                                                   novaBloc.inPickupDetailResponse.add(outPickupDetailResponseSnapshot.data!);
//                                                                                 },
//                                                                                 child: const Icon(
//                                                                                   PhosphorIcons.plus,
//                                                                                   color: link,
//                                                                                   size: 15,
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                     Text(
//                                                                       outPickupDetailResponseSnapshot
//                                                                           .data!
//                                                                           .application![
//                                                                               0]
//                                                                           .products![
//                                                                               productsIndex]
//                                                                           .adminQuantityUnit!,
//                                                                       style:
//                                                                           const TextStyle(
//                                                                         fontWeight:
//                                                                             FontWeight.w400,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       IconButton(
//                                                           onPressed: () {
//                                                             showDialog(
//                                                                 context:
//                                                                     context,
//                                                                 builder:
//                                                                     (context) {
//                                                                   return AlertDialog(
//                                                                     content:
//                                                                         const Text(
//                                                                             "Are you sure about removing this product?"),
//                                                                     actions: [
//                                                                       Padding(
//                                                                         padding:
//                                                                             const EdgeInsets.only(right: 20),
//                                                                         child:
//                                                                             InkWell(
//                                                                           child:
//                                                                               const Text("Yes"),
//                                                                           onTap:
//                                                                               () {
//                                                                             outDeletedProductsIndexListSnapshot.data!.add(productsIndex);
//                                                                             novaBloc.inDeletedProductsIndexList.add(outDeletedProductsIndexListSnapshot.data!);
//                                                                             Navigator.of(context).pop();
//                                                                           },
//                                                                         ),
//                                                                       ),
//                                                                       InkWell(
//                                                                         child: const Text(
//                                                                             "No"),
//                                                                         onTap:
//                                                                             () {
//                                                                           Navigator.of(context)
//                                                                               .pop();
//                                                                         },
//                                                                       ),
//                                                                     ],
//                                                                   );
//                                                                 });
//                                                           },
//                                                           icon: const Icon(
//                                                               PhosphorIcons
//                                                                   .trash_simple))
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             outDeletedProductsIndexListSnapshot
//                                                     .data!
//                                                     .contains(productsIndex)
//                                                 ? Center(
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 30),
//                                                       child: MaterialButton(
//                                                           color: secondary,
//                                                           child: const Padding(
//                                                             padding:
//                                                                 EdgeInsets.only(
//                                                                     top: 10,
//                                                                     bottom: 10),
//                                                             child: Text(
//                                                               "Undo",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .white,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w700),
//                                                             ),
//                                                           ),
//                                                           onPressed: () {
//                                                             outDeletedProductsIndexListSnapshot
//                                                                 .data!
//                                                                 .remove(
//                                                                     productsIndex);
//                                                             novaBloc
//                                                                 .inDeletedProductsIndexList
//                                                                 .add(
//                                                                     outDeletedProductsIndexListSnapshot
//                                                                         .data!);
//                                                           }),
//                                                     ),
//                                                   )
//                                                 : Container(),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                                 ),
//                                 outPickupDetailResponseSnapshot.data!
//                                         .application![0].products!.isNotEmpty
//                                     ? Align(
//                                         alignment: Alignment.bottomCenter,
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 const Text(
//                                                   "Total",
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w700),
//                                                 ),
//                                                 Text(
//                                                   "Rs. $total",
//                                                   style: const TextStyle(
//                                                       color: primary,
//                                                       fontSize: 18,
//                                                       fontWeight:
//                                                           FontWeight.w700),
//                                                 ),
//                                               ],
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   top: 10),
//                                               child: MaterialButton(
//                                                   minWidth:
//                                                       MediaQuery.of(context)
//                                                           .size
//                                                           .width,
//                                                   color: secondary,
//                                                   child: const Padding(
//                                                     padding: EdgeInsets.only(
//                                                         top: 15, bottom: 15),
//                                                     child: Text(
//                                                       "Confirm",
//                                                       style: TextStyle(
//                                                           color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.w700),
//                                                     ),
//                                                   ),
//                                                   onPressed: () {
//                                                     novaBloc
//                                                         .inStartPickupProductsConfirmed
//                                                         .add(true);
//                                                     productsChecked = true;
//                                                     for (int i = 0;
//                                                         i <=
//                                                             outPickupDetailResponseSnapshot
//                                                                 .data!
//                                                                 .application![0]
//                                                                 .products!
//                                                                 .length;
//                                                         i++) {
//                                                       if (outDeletedProductsIndexListSnapshot
//                                                           .data!
//                                                           .contains(i)) {
//                                                         outPickupDetailResponseSnapshot
//                                                             .data!
//                                                             .application![0]
//                                                             .products!
//                                                             .removeAt(i);
//                                                       }
//                                                     }
//                                                     novaBloc
//                                                         .inPickupDetailResponse
//                                                         .add(
//                                                             outPickupDetailResponseSnapshot
//                                                                 .data!);
//                                                     Navigator.of(context).pop();
//                                                   }),
//                                             ),
//                                           ],
//                                         ))
//                                     : Container()
//                               ],
//                             );
//                           });
//                     } else {
//                       return Container();
//                     }
//                   }),
//             ));
//       },
//     );
//   }

//   _confirmationDialogForSignature(String? farmerName) {
//     showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black12.withOpacity(0.6), // Background color
//       barrierDismissible: false,
//       barrierLabel: 'Dialog',
//       transitionDuration: const Duration(milliseconds: 400),
//       pageBuilder: (_, __, ___) {
//         return Scaffold(
//           appBar: AppBar(
//             iconTheme: const IconThemeData(color: Colors.black),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             title: const Text("Signature"),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 10),
//                 child: Center(
//                   child: InkWell(
//                     onTap: () {
//                       _signatureController.clear();
//                     },
//                     child: const Text(
//                       "Clear",
//                       style: TextStyle(color: link),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           body: Padding(
//             padding:
//                 const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 60),
//                   child: Signature(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     controller: _signatureController,
//                     backgroundColor: Colors.white,
//                   ),
//                 ),
//                 Align(
//                     alignment: Alignment.bottomCenter,
//                     child: MaterialButton(
//                         minWidth: MediaQuery.of(context).size.width,
//                         color: secondary,
//                         child: const Padding(
//                           padding: EdgeInsets.only(top: 15, bottom: 15),
//                           child: Text(
//                             "Save",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700),
//                           ),
//                         ),
//                         onPressed: () async {
//                           _signature = await _signatureController.toPngBytes();
//                           // final tempDir = await getTemporaryDirectory();

//                           // _signature = await File(
//                           //         '${tempDir.path}/ ${DateTime.now().toIso8601String().replaceAll(".", ":")}${farmerName}signature.png')
//                           //     .create();
//                           // _signatureFile!.writeAsBytesSync(signature!);
//                           gotSignature = true;
//                           novaBloc.inStartPickupProofSignature.add(_signature!);

//                           Navigator.pop(context);
//                         }))
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future getProofImage({ImageSource? selectedSource}) async {
//     try {
//       var pickedFile =
//           await ImagePicker().pickImage(source: ImageSource.camera);

//       if (pickedFile != null) {
//         Uint8List uint8list =
//             Uint8List.fromList(File(pickedFile.path).readAsBytesSync());

//         _proofImages.add(uint8list);
//         gotproofImages = true;
//         novaBloc.inStartPickupProofImages.add(_proofImages);
//       } else {}
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
// }
