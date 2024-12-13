import 'package:flutter/material.dart';

InputDecoration getAuthenticationInputDecoration(String label) {
  return InputDecoration(

      hintText: label,
      fillColor: Colors.white,
      filled: true, // ativa a função para alterar o fundo
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ));
}
