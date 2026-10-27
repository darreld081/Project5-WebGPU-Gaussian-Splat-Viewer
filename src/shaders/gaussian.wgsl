struct CameraUniforms {
    view: mat4x4<f32>,
    view_inv: mat4x4<f32>,
    proj: mat4x4<f32>,
    proj_inv: mat4x4<f32>,
    viewport: vec2<f32>,
    focal: vec2<f32>
};

struct Gaussian {
    pos_opacity: array<u32,2>,
    rot: array<u32,2>,
    scale: array<u32,2>
}

@group(0) @binding(0)
var<uniform> camera: CameraUniforms;

@group(1) @binding(0)
var<storage,read> gaussians : array<Gaussian>;

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

    let vert = gaussians[instance_index];

    let v1 = unpack2x16float(vert.pos_opacity[0]);
    let v2 = unpack2x16float(vert.pos_opacity[1]);
    let pos = camera.proj * camera.view * vec4<f32>(v1.x, v1.y, v2.x, 1.);
    //fix pos if w less than 0, otherwise calculate actual position
    if pos.w <= 0. {
        out.position = vec4<f32>(2., 2., 2., 1.);
    } else {
        let center_coords = pos.xyz / pos.w;
        out.position = vec4<f32>(center_coords.xy + 
            corners[vertex_index] * square_size * 0.5, 
            center_coords.z, 1.);
    }
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(1.);
}