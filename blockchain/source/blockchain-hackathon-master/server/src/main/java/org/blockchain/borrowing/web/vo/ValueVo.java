package org.blockchain.borrowing.web.vo;

public class ValueVo {

    private Object data;

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public static ValueVo aValue(Object o) {
        ValueVo v = new ValueVo();
        v.setData(o);
        return v;
    }
}
