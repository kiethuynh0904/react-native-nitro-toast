#include <jni.h>
#include "NitroToastOnLoad.hpp"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void*) {
  return margelo::nitro::nitrotoast::initialize(vm);
}
