import { Descriptor, RNOHContext, Tag ,RNViewBase} from "rnoh";
export const SVG_RADIAL_GRADIENT_TYPE_NAME = "RNSVGRadialGradient";

export type SVGRadialGradientDescriptor = Descriptor<"RNSVGRadialGradient">;


@Component
export struct SVGRadialGradient {
  ctx!: RNOHContext;
  tag: number = 0;
  @State descriptor: SVGRadialGradientDescriptor = {} as SVGRadialGradientDescriptor;

  aboutToAppear(): void {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<SVGRadialGradientDescriptor>(this.tag);
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      // 空白占位
    }
  }
}
