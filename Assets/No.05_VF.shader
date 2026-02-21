Shader "LefShader/No.05_VF"
{

    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata //メッシュから頂点シェーダへの入力
            {
                float4 vertex : POSITION; //model空間座標
                float3 normal : NORMAL;
            };

            struct v2f//頂点シェーダからフラグメントシェーダへの出力
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert (appdata v)//vは、今処理しているメッシュの1頂点
            {
                v2f o; //oは、この頂点からフラグメントへ渡したい情報
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target//iは、三角形内部で補間された値
            {
                float3 normal = normalize(i.worldNormal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float NdotL = saturate(dot(normal, lightDir));

                float3 albedo = float3(0.6,0.7,0.4);
                float3 diffuse = albedo*_LightColor0.rgb*NdotL;

                return float4(diffuse, 0.6);
            }
            ENDCG
        }
    }
}
