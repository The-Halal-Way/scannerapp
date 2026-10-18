import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scannerapp/feature/catalog/data/demo_catalog.dart';
import 'package:scannerapp/feature/search/presentation/providers/search_filter_provider.dart';

void main() {
  test('each dashboard category contains demo products', () {
    final filters = SearchFilterProvider();
    addTearDown(filters.dispose);

    expect(DemoCatalog.categories.length, 8);
    for (final category in DemoCatalog.categories) {
      filters.setCategory(category.id);
      expect(filters.results, isNotEmpty, reason: category.name);
    }
  });

  test('combines catalog filters and clears them for a fresh search', () {
    final filters = SearchFilterProvider();
    addTearDown(filters.dispose);

    filters.setQuery('paracetamol');
    filters.setCategory('pain');
    filters.setCompany('square');
    filters.setOnlyOffers(true);
    filters.setOnlyInStock(true);
    filters.setPriceRange(const RangeValues(200, 250));

    expect(filters.results.map((product) => product.id), ['p01']);
    expect(filters.activeFilterCount, 5);

    filters.setPriceRange(const RangeValues(0, 200));
    expect(filters.results, isEmpty);

    filters.clearAll();
    expect(filters.query, isEmpty);
    expect(filters.activeFilterCount, 0);
    expect(filters.results.length, DemoCatalog.products.length);
  });
}
