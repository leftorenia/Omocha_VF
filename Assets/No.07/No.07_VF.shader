Shader "LefShader/No.07_VF"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = _WorldSpaceCameraPos - worldPos;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);
                float3 viewDir = normalize(i.viewDir);

                fixed3 baseColor = fixed3(0.05,0.1,0.0);
                fixed3 rimColor  = fixed3(0.5,0.7,0.5);

                float rim = 1.0 - saturate(dot(viewDir, normal));
                float rimFactor = pow(rim,2.5);

                fixed3 finalColor = baseColor + rimColor * rimFactor;

                return fixed4(finalColor,1.0);
            }
            ENDCG
        }
    }
}