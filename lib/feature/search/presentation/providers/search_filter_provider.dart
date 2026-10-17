import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/catalog/data/models/product.dart';

enum CatalogSort { featured, priceLow, priceHigh, name }

class SearchFilterProvider extends ChangeNotifier {
  SearchFilterProvider({
    String? initialCategoryId,
    String? initialCompanyId,
    bool initialOnlyOffers = false,
  }) : _categoryId = initialCategoryId,
       _companyId = initialCompanyId,
       _onlyOffers = initialOnlyOffers {
    _priceRange = RangeValues(0, maxPrice);
  }

  String _query = '';
  String? _categoryId;
  String? _companyId;
  bool _onlyOffers;
  bool _onlyInStock = false;
  CatalogSort _sort = CatalogSort.featured;
  late RangeValues _priceRange;

  String get query => _query;
  String? get categoryId => _categoryId;
  String? get companyId => _companyId;
  bool get onlyOffers => _onlyOffers;
  bool get onlyInStock => _onlyInStock;
  CatalogSort get sort => _sort;
  RangeValues get priceRange => _priceRange;

  double get maxPrice {
    final highest = DemoCatalog.products.fold<double>(
      0,
      (value, product) => math.max(value, product.price.toDouble()),
    );
    return math.max(100, (highest / 100).ceil() * 100).toDouble();
  }

  int get activeFilterCount => [
    _categoryId != null,
    _companyId != null,
    _onlyOffers,
    _onlyInStock,
    _priceRange.start > 0 || _priceRange.end < maxPrice,
  ].where((active) => active).length;

  List<Product> get results {
    final lowerQuery = _query.trim().toLowerCase();
    final products = DemoCatalog.products.where((product) {
      if (_categoryId != null && product.categoryId != _categoryId) {
        return false;
      }
      if (_companyId != null && product.companyId != _companyId) return false;
      if (_onlyOffers && !product.isOffer) return false;
      if (_onlyInStock && product.stock < 1) return false;
      if (product.price < _priceRange.start ||
          product.price > _priceRange.end) {
        return false;
      }
      if (lowerQuery.isEmpty) return true;
      final companyName = DemoCatalog.companies
          .where((company) => company.id == product.companyId)
          .map((company) => company.name)
          .firstOrNull;
      final categoryName = DemoCatalog.categories
          .where((category) => category.id == product.categoryId)
          .map((category) => category.name)
          .firstOrNull;
      return [
        product.name,
        product.genericName,
        companyName ?? '',
        categoryName ?? '',
      ].any((value) => value.toLowerCase().contains(lowerQuery));
    }).toList();

    switch (_sort) {
      case CatalogSort.featured:
        products.sort((a, b) {
          final byPopular = (b.isPopular ? 1 : 0).compareTo(
            a.isPopular ? 1 : 0,
          );
          return byPopular != 0 ? byPopular : a.name.compareTo(b.name);
        });
      case CatalogSort.priceLow:
        products.sort((a, b) => a.price.compareTo(b.price));
      case CatalogSort.priceHigh:
        products.sort((a, b) => b.price.compareTo(a.price));
      case CatalogSort.name:
        products.sort((a, b) => a.name.compareTo(b.name));
    }
    return products;
  }

  void setQuery(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void setCategory(String? value) {
    if (_categoryId == value) return;
    _categoryId = value;
    notifyListeners();
  }

  void setCompany(String? value) {
    if (_companyId == value) return;
    _companyId = value;
    notifyListeners();
  }

  void setOnlyOffers(bool value) {
    if (_onlyOffers == value) return;
    _onlyOffers = value;
    notifyListeners();
  }

  void setOnlyInStock(bool value) {
    if (_onlyInStock == value) return;
    _onlyInStock = value;
    notifyListeners();
  }

  void setSort(CatalogSort value) {
    if (_sort == value) return;
    _sort = value;
    notifyListeners();
  }

  void setPriceRange(RangeValues value) {
    _priceRange = value;
    notifyListeners();
  }

  void resetFilters() {
    _categoryId = null;
    _companyId = null;
    _onlyOffers = false;
    _onlyInStock = false;
    _sort = CatalogSort.featured;
    _priceRange = RangeValues(0, maxPrice);
    notifyListeners();
  }

  void clearAll() {
    _query = '';
    resetFilters();
  }
}
