struct Splat {
    center: u32,
    size: u32,
    color_a: u32,
    color_b: u32,
};

@group(0) @binding(0)
var<storage,read> splatArr : array<Splat>;
@group(0) @binding(1)
var<storage,read> sortIndices : array<u32>;

struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) vertex_color: vec4<f32>,
    //TODO: information passed from vertex shader to fragment shader
};

//create array representing the square corners
var<private> corners = array<vec2<f32>, 6>(vec2<f32>(-1., -1.),vec2<f32>( 1., -1.),vec2<f32>(-1.,  1.),vec2<f32>(-1.,  1.),vec2<f32>( 1., -1.),vec2<f32>( 1.,  1.),);

@vertex
fn vs_main(
    @builtin(vertex_index) vert: u32,
    @builtin(instance_index) instance: u32,
) -> VertexOutput {
    var out: VertexOutput;
    // splats are drawn in sorted (far to near) order
    let splat = splatArr[sortIndices[instance]];
    //convert to float
    let size = unpack2x16float(splat.size);
    let center = unpack2x16float(splat.center);
    let cornerOffset = size * corners[vert] * 0.5;
    let outX = center + cornerOffset;
    let out_y = 0.;
    let out_z = 1.;
    out.position = vec4<f32>(outX, out_y, out_z);
    out.vertex_color = vec4<f32>(unpack2x16float(splat.color_a), unpack2x16float(splat.color_b));
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    return in.vertex_color;
}
