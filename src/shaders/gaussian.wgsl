struct Splat {
    center: u32,
    size: u32,
};

@group(0) @binding(0)
var<storage,read> splatArr : array<Splat>;

struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    //TODO: information passed from vertex shader to fragment shader
};

//create array representing the square corners
var<private> corners = array<vec2<f32>, 6>(vec2<f32>(-1., -1.),vec2<f32>( 1., -1.),vec2<f32>(-1.,  1.),vec2<f32>(-1.,  1.),vec2<f32>( 1., -1.),vec2<f32>( 1.,  1.),);

@vertex
fn vs_main(
    @builtin(vertex_index) vertex_index: u32,
    @builtin(instance_index) instance_index: u32,
) -> VertexOutput {
    var out: VertexOutput;
    let u32center = splatArr[instance_index].center;
    let u32size = splatArr[instance_index].size;
    //convert to float
    let size = unpack2x16float(u32size);
    let center = unpack2x16float(u32center);
    let cornerOffset = size * corners[vertex_index] * 0.5;
    let out_x = center + cornerOffset;
    let out_y = 0.;
    let out_z = 1.;
    out.position = vec4<f32>(out_x, out_y, out_z);
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(1.);
}