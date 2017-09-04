package;

class Utils {
    public static inline function lerp (a : Float, begin : Float, end : Float) {
        return begin + a * (end - begin);
    }
}
