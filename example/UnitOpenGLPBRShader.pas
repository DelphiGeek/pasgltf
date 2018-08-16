unit UnitOpenGLPBRShader;
{$ifdef fpc}
 {$mode delphi}
 {$ifdef cpui386}
  {$define cpu386}
 {$endif}
 {$ifdef cpuamd64}
  {$define cpux86_64}
 {$endif}
 {$ifdef cpu386}
  {$define cpux86}
  {$define cpu32}
  {$asmmode intel}
 {$endif}
 {$ifdef cpux86_64}
  {$define cpux64}
  {$define cpu64}
  {$asmmode intel}
 {$endif}
 {$ifdef FPC_LITTLE_ENDIAN}
  {$define LITTLE_ENDIAN}
 {$else}
  {$ifdef FPC_BIG_ENDIAN}
   {$define BIG_ENDIAN}
  {$endif}
 {$endif}
 {-$pic off}
 {$define caninline}
 {$ifdef FPC_HAS_TYPE_EXTENDED}
  {$define HAS_TYPE_EXTENDED}
 {$else}
  {$undef HAS_TYPE_EXTENDED}
 {$endif}
 {$ifdef FPC_HAS_TYPE_DOUBLE}
  {$define HAS_TYPE_DOUBLE}
 {$else}
  {$undef HAS_TYPE_DOUBLE}
 {$endif}
 {$ifdef FPC_HAS_TYPE_SINGLE}
  {$define HAS_TYPE_SINGLE}
 {$else}
  {$undef HAS_TYPE_SINGLE}
 {$endif}
 {$if declared(RawByteString)}
  {$define HAS_TYPE_RAWBYTESTRING}
 {$else}
  {$undef HAS_TYPE_RAWBYTESTRING}
 {$ifend}
 {$if declared(UTF8String)}
  {$define HAS_TYPE_UTF8STRING}
 {$else}
  {$undef HAS_TYPE_UTF8STRING}
 {$ifend}
{$else}
 {$realcompatibility off}
 {$localsymbols on}
 {$define LITTLE_ENDIAN}
 {$ifndef cpu64}
  {$define cpu32}
 {$endif}
 {$ifdef cpux64}
  {$define cpux86_64}
  {$define cpu64}
 {$else}
  {$ifdef cpu386}
   {$define cpux86}
   {$define cpu32}
  {$endif}
 {$endif}
 {$define HAS_TYPE_EXTENDED}
 {$define HAS_TYPE_DOUBLE}
 {$ifdef conditionalexpressions}
  {$if declared(RawByteString)}
   {$define HAS_TYPE_RAWBYTESTRING}
  {$else}
   {$undef HAS_TYPE_RAWBYTESTRING}
  {$ifend}
  {$if declared(UTF8String)}
   {$define HAS_TYPE_UTF8STRING}
  {$else}
   {$undef HAS_TYPE_UTF8STRING}
  {$ifend}
 {$else}
  {$undef HAS_TYPE_RAWBYTESTRING}
  {$undef HAS_TYPE_UTF8STRING}
 {$endif}
{$endif}
{$ifdef win32}
 {$define windows}
{$endif}
{$ifdef win64}
 {$define windows}
{$endif}
{$ifdef wince}
 {$define windows}
{$endif}
{$rangechecks off}
{$extendedsyntax on}
{$writeableconst on}
{$hints off}
{$booleval off}
{$typedaddress off}
{$stackframes off}
{$varstringchecks on}
{$typeinfo on}
{$overflowchecks off}
{$longstrings on}
{$openstrings on}

interface

uses dglOpenGL,UnitOpenGLShader;

type TPBRShader=class(TShader)
      public
       uBaseColorFactor:glInt;
       uBaseColorTexture:glInt;
       uMetallicRoughnessTexture:glInt;
       uNormalTexture:glInt;
       uOcclusionTexture:glInt;
       uEmissiveTexture:glInt;
       uTextureFlags:glInt;
       uMetallicRoughnessNormalScaleOcclusionStrengthFactor:glInt;
       uEmissiveFactor:glInt;
       uModelMatrix:glInt;
       uModelViewMatrix:glInt;
       uModelViewProjectionMatrix:glInt;
       uLightDirection:glInt;
       constructor Create;
       destructor Destroy; override;
       procedure BindAttributes; override;
       procedure BindVariables; override;
      end;

implementation

constructor TPBRShader.Create;
var f,v:ansistring;
begin
 v:='#version 330'+#13#10+
    'layout(location = 0) in vec3 aPosition;'+#13#10+
    'layout(location = 1) in vec3 aNormal;'+#13#10+
    'layout(location = 2) in vec4 aTangent;'+#13#10+
    'layout(location = 3) in vec2 aTexCoord0;'+#13#10+
    'layout(location = 4) in vec2 aTexCoord1;'+#13#10+
    'layout(location = 5) in vec4 aColor0;'+#13#10+
    'layout(location = 6) in vec4 aJoints0;'+#13#10+
    'layout(location = 7) in vec4 aJoints1;'+#13#10+
    'layout(location = 8) in vec4 aWeights0;'+#13#10+
    'layout(location = 9) in vec4 aWeights1;'+#13#10+
    'uniform mat4 uModelMatrix;'+#13#10+
    'uniform mat4 uModelViewMatrix;'+#13#10+
    'uniform mat4 uModelViewProjectionMatrix;'+#13#10+
    'out vec3 vViewSpacePosition;'+#13#10+
    'out vec2 vTexCoord0;'+#13#10+
    'out vec2 vTexCoord1;'+#13#10+
    'out vec3 vNormal;'+#13#10+
    'out vec3 vTangent;'+#13#10+
    'out vec3 vBitangent;'+#13#10+
    'out vec4 vColor;'+#13#10+
    'void main(){'+#13#10+
      'mat3 baseMatrix = transpose(inverse(mat3(uModelMatrix)));'+#13#10+
      'vNormal = baseMatrix * aNormal;'+#13#10+
      'vTangent = baseMatrix * aTangent.xyz;'+#13#10+
      'vBitangent = cross(vNormal, vTangent) * aTangent.w;'+#13#10+
      'vTexCoord0 = aTexCoord0;'+#13#10+
      'vTexCoord1 = aTexCoord1;'+#13#10+
      'vColor = aColor0;'+#13#10+
      'vViewSpacePosition = (uModelViewMatrix * vec4(aPosition,1.0)).xyz;'+#13#10+
      'gl_Position = uModelViewProjectionMatrix * vec4(aPosition,1.0);'+#13#10+
    '}'+#13#10;
 f:='#version 330'+#13#10+
    'layout(location = 0) out vec4 oOutput;'+#13#10+
    'in vec3 vViewSpacePosition;'+#13#10+
    'in vec2 vTexCoord0;'+#13#10+
    'in vec2 vTexCoord1;'+#13#10+
    'in vec3 vNormal;'+#13#10+
    'in vec3 vTangent;'+#13#10+
    'in vec3 vBitangent;'+#13#10+
    'in vec4 vColor;'+#13#10+
    'uniform sampler2D uBaseColorTexture;'+#13#10+
    'uniform sampler2D uMetallicRoughnessTexture;'+#13#10+
    'uniform sampler2D uNormalTexture;'+#13#10+
    'uniform sampler2D uOcclusionTexture;'+#13#10+
    'uniform sampler2D uEmissiveTexture;'+#13#10+
    'uniform uint uTextureFlags;'+#13#10+
    'uniform vec4 uBaseColorFactor;'+#13#10+
    'uniform vec3 uEmissiveFactor;'+#13#10+
    'uniform vec4 uMetallicRoughnessNormalScaleOcclusionStrengthFactor;'+#13#10+
    'uniform vec3 uLightDirection;'+#13#10+
    'const float PI = 3.14159265358979323846;'+#13#10+
    'vec3 diffuseLambert(vec3 diffuseColor){'+#13#10+
    '  return diffuseColor * (1.0 / 3.14159265358979323846);'+#13#10+
    '}'+#13#10+
    'vec3 diffuseFunction(vec3 diffuseColor, float roughness, float nDotV, float nDotL, float vDotH){'+#13#10+
    '  float FD90 = 0.5 + (2.0 * (vDotH * vDotH * roughness)),'+#13#10+
    '        FdV = 1.0 + ((FD90 - 1.0) * pow(1.0 - nDotV, 5.0)),'+#13#10+
    '        FdL = 1.0 + ((FD90 - 1.0) * pow(1.0 - nDotL, 5.0));'+#13#10+
    '  return diffuseColor * ((1.0 / 3.14159265358979323846) * FdV * FdL);'+#13#10+
    '}'+#13#10+
    'vec3 specularF(const in vec3 specularColor, const in float vDotH){'+#13#10+
    '  float fc = pow(1.0 - vDotH, 5.0);'+#13#10+
    '  return vec3(clamp(50.0 * specularColor.g, 0.0, 1.0) * fc) + ((1.0 - fc) * specularColor);'+#13#10+
    '}'+#13#10+
    'float specularD(const in float roughness, const in float nDotH){'+#13#10+
    '  float a = roughness * roughness;'+#13#10+
    '  float a2 = a * a;'+#13#10+
    '  float d = (((nDotH * a2) - nDotH) * nDotH) + 1.0;'+#13#10+
    '  return a2 / (3.14159265358979323846 * (d * d));'+#13#10+
    '}'+#13#10+
    'float specularG(const in float roughness, const in float nDotV, const in float nDotL){'+#13#10+
    '  float k = (roughness * roughness) * 0.5;'+#13#10+
    '  vec2 GVL = (vec2(nDotV, nDotL) * (1.0 - k)) + vec2(k);'+#13#10+
    '  return 0.25 / (GVL.x * GVL.y);'+#13#10+
    '}'+#13#10+
    'vec3 doSingleLight(const in vec3 lightColor,'+#13#10+
    '                   const in vec3 lightLit,'+#13#10+
    '                   const in vec3 lightDirection,'+#13#10+
    '                   const in vec3 normal,'+#13#10+
    '                   const in vec3 diffuseColor,'+#13#10+
    '                   const in vec3 specularColor,'+#13#10+
    '                   const in vec3 viewDirection,'+#13#10+
    '                   const in float refractiveAngle,'+#13#10+
    '                   const in float materialTransparency,'+#13#10+
    '                   const in float materialRoughness,'+#13#10+
    '                   const in float materialCavity,'+#13#10+
    '                   const in float materialMetallic){'+#13#10+
    '  vec3 halfVector = normalize(viewDirection + lightDirection);'+#13#10+
    '	 float nDotL = clamp(dot(normal, lightDirection), 1e-5, 1.0);'+#13#10+
    '	 float nDotV = clamp(dot(normal, viewDirection), 1e-5, 1.0);'+#13#10+
    '	 float nDotH = clamp(dot(normal, halfVector), 0.0, 1.0);'+#13#10+
    '	 float vDotH = clamp(dot(viewDirection, halfVector), 0.0, 1.0);'+#13#10+
    '  vec3 diffuse = diffuseFunction(diffuseColor, materialRoughness, nDotV, nDotL, vDotH) * (1.0 - materialTransparency);'+#13#10+
    '	 vec3 specular = specularF(specularColor, max(vDotH, refractiveAngle)) *'+#13#10+
    '                   specularD(materialRoughness, nDotH) *'+#13#10+
    '                   specularG(materialRoughness, nDotV, nDotL);'+#13#10+
    '	 return (diffuse + specular) * ((materialCavity * nDotL * lightColor) * lightLit);'+#13#10+
    '}'+#13#10+
    'vec3 ACESFilm(vec3 x){'+#13#10+
    '  const float a = 2.51, b = 0.03, c = 2.43, d = 0.59, e = 0.14f;'+#13#10+
    '  return pow(clamp((x * ((a * x) + vec3(b))) / (x * ((c * x) + vec3(d)) + vec3(e)), vec3(0.0), vec3(1.0)), vec3(1.0 / 2.2));'+#13#10+
    '}'+#13#10+
    'vec3 toneMappingAndToLDR(vec3 x){'+#13#10+
    '  float exposure = 1.0;'+#13#10+
    '  return ACESFilm(x * exposure);'+#13#10+
    '}'+#13#10+
    'void main(){'+#13#10+
    '  vec4 baseColorTexture, metallicRoughnessTexture, normalTexture, occlusionTexture, emissiveTexture;'+#13#10+
    '  if((uTextureFlags & 1u) != 0){'+#13#10+
    '    baseColorTexture = texture(uBaseColorTexture, ((uTextureFlags & 2u) != 0) ? vTexCoord1 : vTexCoord0);'+#13#10+
    '  }else{'+#13#10+
    '    baseColorTexture = vec4(1.0);'+#13#10+
    '  }'+#13#10+
    '  if((uTextureFlags & 4u) != 0){'+#13#10+
    '    metallicRoughnessTexture = texture(uMetallicRoughnessTexture, ((uTextureFlags & 8u) != 0) ? vTexCoord1 : vTexCoord0);'+#13#10+
    '  }else{'+#13#10+
    '    metallicRoughnessTexture = vec4(1.0);'+#13#10+
    '  }'+#13#10+
    '  if((uTextureFlags & 16u) != 0){'+#13#10+
    '    normalTexture = normalize(texture(uNormalTexture, ((uTextureFlags & 32u) != 0) ? vTexCoord1 : vTexCoord0) - vec4(0.5));'+#13#10+
    '  }else{'+#13#10+
    '    normalTexture = vec2(0.0, 1.0).xxyx;'+#13#10+
    '  }'+#13#10+
    '  if((uTextureFlags & 64u) != 0){'+#13#10+
    '    occlusionTexture = texture(uOcclusionTexture, ((uTextureFlags & 128u) != 0) ? vTexCoord1 : vTexCoord0);'+#13#10+
    '  }else{'+#13#10+
    '    occlusionTexture = vec4(1.0);'+#13#10+
    '  }'+#13#10+
    '  if((uTextureFlags & 256u) != 0){'+#13#10+
    '    emissiveTexture = texture(uEmissiveTexture, ((uTextureFlags & 512u) != 0) ? vTexCoord1 : vTexCoord0);'+#13#10+
    '  }else{'+#13#10+
    '    emissiveTexture = vec4(0.0);'+#13#10+
    '  }'+#13#10+
    '  mat3 tangentSpace = mat3(normalize(vTangent), normalize(vBitangent), normalize(vNormal));'+#13#10+
    '  vec4 materialAlbedo = vec4(pow(baseColorTexture.xyz, vec3(2.2)), baseColorTexture.w) * uBaseColorFactor,'+#13#10+
    '       materialNormal = vec4(normalize(tangentSpace * normalTexture.xyz), normalTexture.w * uMetallicRoughnessNormalScaleOcclusionStrengthFactor.z);'+#13#10+
    '  float materialRoughness = max(1e-3, metallicRoughnessTexture.y * uMetallicRoughnessNormalScaleOcclusionStrengthFactor.y),'+#13#10+
    '        materialCavity = occlusionTexture.x * uMetallicRoughnessNormalScaleOcclusionStrengthFactor.w,'+#13#10+
    '        materialMetallic = metallicRoughnessTexture.z * uMetallicRoughnessNormalScaleOcclusionStrengthFactor.x,'+#13#10+
    '        materialTransparency = 0.0,'+#13#10+
    '        refractiveAngle = 0.0,'+#13#10+
    '        ambientOcclusion = 1.0,'+#13#10+
    '        shadow = 1.0;'+#13#10+
    '  vec3 viewDirection = normalize(vViewSpacePosition),'+#13#10+
    '       diffuseColor = materialAlbedo.xyz * (1.0 - materialMetallic) * PI,'+#13#10+
    '       specularColor = mix(vec3(0.04), materialAlbedo.xyz, materialMetallic) * PI;'+#13#10+
{   '  vec3 color = (doSingleLight(vec3(1.70, 1.15, 0.70),'+#13#10+
    '                              pow(vec3(shadow), vec3(1.05, 1.02, 1.0)),'+#13#10+
    '                              -uLightDirection,'+#13#10+
    '                              materialNormal.xyz,'+#13#10+
    '                              diffuseColor,'+#13#10+
    '                              specularColor,'+#13#10+
    '                              viewDirection,'+#13#10+
    '                              refractiveAngle,'+#13#10+
    '                              materialTransparency,'+#13#10+
    '                              materialRoughness,'+#13#10+
    '                              materialCavity,'+#13#10+
    '                              materialMetallic) +'+#13#10+
    '                (((('+#13#10+
    '                    // Sky light'+#13#10+
    '                    (max(0.0, 0.6 + (0.4 * materialNormal.y)) * vec3(0.05, 0.20, 0.45)) +'+#13#10+
    '                    // Backlight'+#13#10+
    '                    (max(0.0, 0.2 + (0.8 * dot(materialNormal.xyz, normalize(vec3(uLightDirection.xz, 0.0).xzy)))) * vec3(0.20, 0.25, 0.25))'+#13#10+
    '                   ) * ambientOcclusion) +'+#13#10+
    '                  // Bounce light'+#13#10+
    '                  (clamp(-materialNormal.y, 0.0, 1.0) * vec3(0.18, 0.24, 0.24) * mix(0.5, 1.0, ambientOcclusion))'+#13#10+
    '                 ) * diffuseLambert(diffuseColor) * materialCavity));'+#13#10+}
    '  vec3 color = vec3(0.0);'+#13#10+
    '  color += doSingleLight(vec3(1.70, 1.15, 0.70),'+#13#10+ // Sun light
    '                         pow(vec3(shadow), vec3(1.05, 1.02, 1.0)),'+#13#10+
    '                         -uLightDirection,'+#13#10+
    '                         materialNormal.xyz,'+#13#10+
    '                         diffuseColor,'+#13#10+
    '                         specularColor,'+#13#10+
    '                         viewDirection,'+#13#10+
    '                         refractiveAngle,'+#13#10+
    '                         materialTransparency,'+#13#10+
    '                         materialRoughness,'+#13#10+
    '                         materialCavity,'+#13#10+
    '                         materialMetallic)*1.0;'+#13#10+
    '  color += doSingleLight(vec3(0.20, 0.25, 0.25),'+#13#10+ // Fake-GI sky back light
    '                         vec3(ambientOcclusion),'+#13#10+
    '                         normalize(vec3(uLightDirection.xz, 0.0).xzy),'+#13#10+
    '                         materialNormal.xyz,'+#13#10+
    '                         diffuseColor,'+#13#10+
    '                         specularColor,'+#13#10+
    '                         viewDirection,'+#13#10+
    '                         refractiveAngle,'+#13#10+
    '                         materialTransparency,'+#13#10+
    '                         materialRoughness,'+#13#10+
    '                         materialCavity,'+#13#10+
    '                         materialMetallic)*1.0;'+#13#10+
    '  color += doSingleLight(vec3(0.18, 0.24, 0.24),'+#13#10+ // Fake-GI sky bounce light
    '                         vec3(mix(0.5, 1.0, ambientOcclusion)),'+#13#10+
    '                         vec3(0.0, -1.0, 0.0),'+#13#10+
    '                         materialNormal.xyz,'+#13#10+
    '                         diffuseColor,'+#13#10+
    '                         specularColor,'+#13#10+
    '                         viewDirection,'+#13#10+
    '                         refractiveAngle,'+#13#10+
    '                         materialTransparency,'+#13#10+
    '                         materialRoughness,'+#13#10+
    '                         materialCavity,'+#13#10+
    '                         materialMetallic)*1.0;'+#13#10+
    '  color += doSingleLight(vec3(0.05, 0.20, 0.45),'+#13#10+ // Fake-GI sky light
    '                         vec3(ambientOcclusion),'+#13#10+
    '                         normalize(vec3(materialNormal.x, 1.0, materialNormal.z)),'+#13#10+
    '                         materialNormal.xyz,'+#13#10+
    '                         diffuseColor,'+#13#10+
    '                         specularColor,'+#13#10+
    '                         viewDirection,'+#13#10+
    '                         refractiveAngle,'+#13#10+
    '                         materialTransparency,'+#13#10+
    '                         materialRoughness,'+#13#10+
    '                         materialCavity,'+#13#10+
    '                         materialMetallic)*1.0;'+#13#10+
//    '  color = (max(0.0, 0.6 + (0.4 * materialNormal.y)) * vec3(0.05, 0.20, 0.45)) * diffuseColor * materialCavity;'+#13#10+
//   ' color = clamp(-materialNormal.y, 0.0, 1.0) * vec3(0.18, 0.24, 0.24) * diffuseColor * materialCavity;'+#13#10+
    '  oOutput = vec4(toneMappingAndToLDR((color + emissiveTexture.xyz) * vColor.xyz), materialAlbedo.w * vColor.w);'+#13#10+
   '}'+#13#10;
 inherited Create(f,v);
end;

destructor TPBRShader.Destroy;
begin
 inherited Destroy;
end;

procedure TPBRShader.BindAttributes;
begin
 inherited BindAttributes;
 glBindAttribLocation(ProgramHandle,0,'aPosition');
 glBindAttribLocation(ProgramHandle,1,'aNormal');
 glBindAttribLocation(ProgramHandle,2,'aTangent');
 glBindAttribLocation(ProgramHandle,3,'aTexCoord0');
 glBindAttribLocation(ProgramHandle,4,'aTexCoord1');
 glBindAttribLocation(ProgramHandle,5,'aColor0');
 glBindAttribLocation(ProgramHandle,6,'aJoints0');
 glBindAttribLocation(ProgramHandle,7,'aJoints1');
 glBindAttribLocation(ProgramHandle,8,'aWeights0');
 glBindAttribLocation(ProgramHandle,9,'aWeights1');
end;

procedure TPBRShader.BindVariables;
begin
 inherited BindVariables;
 uBaseColorFactor:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uBaseColorFactor')));
 uBaseColorTexture:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uBaseColorTexture')));
 uMetallicRoughnessTexture:=glGetUniformLocation(ProgramHandle,pointer(pansichar('PBRMetallicRoughnessMetallicRoughnessTexture')));
 uNormalTexture:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uNormalTexture')));
 uOcclusionTexture:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uOcclusionTexture')));
 uEmissiveTexture:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uEmissiveTexture')));
 uEmissiveFactor:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uEmissiveFactor')));
 uMetallicRoughnessNormalScaleOcclusionStrengthFactor:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uMetallicRoughnessNormalScaleOcclusionStrengthFactor')));
 uTextureFlags:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uTextureFlags')));
 uModelMatrix:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uModelMatrix')));
 uModelViewMatrix:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uModelViewMatrix')));
 uModelViewProjectionMatrix:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uModelViewProjectionMatrix')));
 uLightDirection:=glGetUniformLocation(ProgramHandle,pointer(pansichar('uLightDirection')));
end;

end.