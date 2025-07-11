///
/// JHybridNitroToastSpec.cpp
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2025 Marc Rousavy @ Margelo
///

#include "JHybridNitroToastSpec.hpp"

// Forward declaration of `NitroToastConfig` to properly resolve imports.
namespace margelo::nitro::nitrotoast { struct NitroToastConfig; }
// Forward declaration of `AlertToastType` to properly resolve imports.
namespace margelo::nitro::nitrotoast { enum class AlertToastType; }
// Forward declaration of `PresentationToastType` to properly resolve imports.
namespace margelo::nitro::nitrotoast { enum class PresentationToastType; }
// Forward declaration of `PositionToastType` to properly resolve imports.
namespace margelo::nitro::nitrotoast { enum class PositionToastType; }

#include <string>
#include "NitroToastConfig.hpp"
#include "JNitroToastConfig.hpp"
#include <optional>
#include "AlertToastType.hpp"
#include "JAlertToastType.hpp"
#include "PresentationToastType.hpp"
#include "JPresentationToastType.hpp"
#include "PositionToastType.hpp"
#include "JPositionToastType.hpp"

namespace margelo::nitro::nitrotoast {

  jni::local_ref<JHybridNitroToastSpec::jhybriddata> JHybridNitroToastSpec::initHybrid(jni::alias_ref<jhybridobject> jThis) {
    return makeCxxInstance(jThis);
  }

  void JHybridNitroToastSpec::registerNatives() {
    registerHybrid({
      makeNativeMethod("initHybrid", JHybridNitroToastSpec::initHybrid),
    });
  }

  size_t JHybridNitroToastSpec::getExternalMemorySize() noexcept {
    static const auto method = javaClassStatic()->getMethod<jlong()>("getMemorySize");
    return method(_javaPart);
  }

  // Properties
  

  // Methods
  std::string JHybridNitroToastSpec::show(const std::string& message, const NitroToastConfig& config) {
    static const auto method = javaClassStatic()->getMethod<jni::local_ref<jni::JString>(jni::alias_ref<jni::JString> /* message */, jni::alias_ref<JNitroToastConfig> /* config */)>("show");
    auto __result = method(_javaPart, jni::make_jstring(message), JNitroToastConfig::fromCpp(config));
    return __result->toStdString();
  }
  void JHybridNitroToastSpec::dismiss(const std::string& toastId) {
    static const auto method = javaClassStatic()->getMethod<void(jni::alias_ref<jni::JString> /* toastId */)>("dismiss");
    method(_javaPart, jni::make_jstring(toastId));
  }

} // namespace margelo::nitro::nitrotoast
