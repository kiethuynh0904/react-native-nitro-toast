///
/// JPresentationToastType.hpp
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2025 Marc Rousavy @ Margelo
///

#pragma once

#include <fbjni/fbjni.h>
#include "PresentationToastType.hpp"

namespace margelo::nitro::nitrotoast {

  using namespace facebook;

  /**
   * The C++ JNI bridge between the C++ enum "PresentationToastType" and the the Kotlin enum "PresentationToastType".
   */
  struct JPresentationToastType final: public jni::JavaClass<JPresentationToastType> {
  public:
    static auto constexpr kJavaDescriptor = "Lcom/margelo/nitro/nitrotoast/PresentationToastType;";

  public:
    /**
     * Convert this Java/Kotlin-based enum to the C++ enum PresentationToastType.
     */
    [[maybe_unused]]
    [[nodiscard]]
    PresentationToastType toCpp() const {
      static const auto clazz = javaClassStatic();
      static const auto fieldOrdinal = clazz->getField<int>("_ordinal");
      int ordinal = this->getFieldValue(fieldOrdinal);
      return static_cast<PresentationToastType>(ordinal);
    }

  public:
    /**
     * Create a Java/Kotlin-based enum with the given C++ enum's value.
     */
    [[maybe_unused]]
    static jni::alias_ref<JPresentationToastType> fromCpp(PresentationToastType value) {
      static const auto clazz = javaClassStatic();
      static const auto fieldALERT = clazz->getStaticField<JPresentationToastType>("ALERT");
      static const auto fieldSTACKED = clazz->getStaticField<JPresentationToastType>("STACKED");
      
      switch (value) {
        case PresentationToastType::ALERT:
          return clazz->getStaticFieldValue(fieldALERT);
        case PresentationToastType::STACKED:
          return clazz->getStaticFieldValue(fieldSTACKED);
        default:
          std::string stringValue = std::to_string(static_cast<int>(value));
          throw std::invalid_argument("Invalid enum value (" + stringValue + "!");
      }
    }
  };

} // namespace margelo::nitro::nitrotoast
