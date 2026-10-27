struct Splat {
    center: u32,
};

@group(0) @binding(0)
var<storage,read> splatArr : array<Splat>;

struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    //TODO: information passed from vertex shader to fragment shader
};

const square_size = 0.01;

//create array representing the square corners
var<private> corners = array<vec2<f32>, 6>(vec2<f32>(-1., -1.),vec2<f32>( 1., -1.),vec2<f32>(-1.,  1.),vec2<f32>(-1.,  1.),vec2<f32>( 1., -1.),vec2<f32>( 1.,  1.),);

@vertex
fn vs_main(
    @builtin(vertex_index) vertex_index: u32,
    @builtin(instance_index) instance_index: u32,
) -> VertexOutput {
    var out: VertexOutput;
    let center = unpack2x16float(splatArr[instance_index].center);
    out.position = vec4<f32>(center + corners[vertex_index] * square_size * 0.5, 0, 1);
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(1.);
}