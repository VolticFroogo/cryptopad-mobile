class MinMax {
    int min, max;

    MinMax(int min, int max) {
        this.min = min;
        this.max = max;
    }

    bool check(int len) {
        return !(len < min || len > max);
    }
}