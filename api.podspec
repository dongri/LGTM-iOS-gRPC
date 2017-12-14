Pod::Spec.new do |s|
  s.name     = "api"
  s.version  = "0.0.1"
  s.license  = "MIT"
  s.authors  = { 'Dongri Jin' => 'dongrify@gmail.com' }
  s.homepage = "https://github.com/dongri"
  s.summary = "gRPC API"
  s.source = { :git => 'https://github.com/dongri/grpc.git' }

  s.ios.deployment_target = "10.1"

  src = "./protos"

  # gRPC Plugin
  s.dependency "!ProtoCompiler-gRPCPlugin", "~> 1.0"

  pods_root = 'Pods'

  protoc_dir = "#{pods_root}/!ProtoCompiler"
  protoc = "#{protoc_dir}/protoc"
  plugin = "#{pods_root}/!ProtoCompiler-gRPCPlugin/grpc_objective_c_plugin"

  dir = "#{pods_root}/#{s.name}"

  # source files
  s.prepare_command = <<-CMD
    mkdir -p #{dir}
    #{protoc} \
        --plugin=protoc-gen-grpc=#{plugin} \
        --objc_out=#{dir} \
        --grpc_out=#{dir} \
        -I #{src} \
        -I #{protoc_dir} \
        #{src}/api.proto
  CMD

  # subspec
  s.subspec "Messages" do |ms|
    ms.source_files = "#{dir}/*.pbobjc.{h,m}", "#{dir}/**/*.pbobjc.{h,m}"
    ms.header_mappings_dir = dir
    ms.requires_arc = false
    ms.dependency "Protobuf"
  end

  # subspec
  s.subspec "Services" do |ss|
    ss.source_files = "#{dir}/*.pbrpc.{h,m}", "#{dir}/**/*.pbrpc.{h,m}"
    ss.header_mappings_dir = dir
    ss.requires_arc = true
    ss.dependency "gRPC-ProtoRPC"
    ss.dependency "#{s.name}/Messages"
  end

  s.pod_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
  }
end

