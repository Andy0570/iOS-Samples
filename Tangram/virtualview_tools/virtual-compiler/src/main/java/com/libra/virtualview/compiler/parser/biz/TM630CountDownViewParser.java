/*
 * MIT License
 *
 * Copyright (c) 2018 Alibaba Group
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.libra.virtualview.compiler.parser.biz;

import com.libra.Log;
import com.libra.TextUtils;
import com.libra.expr.common.StringSupport;
import com.libra.virtualview.common.BizCommon;
import com.libra.virtualview.compiler.parser.Parser;
import com.libra.virtualview.compiler.parser.ViewBaseParser;

/**
 * Created by longerian on 17/4/8.
 *
 * @author longerian
 */
@Deprecated
public class TM630CountDownViewParser extends ViewBaseParser {

    private final static String TAG = "TM630CountDownView_TMTEST";
    private int countBgColorId;
    private int countTextColorId;
    private int countTextSizeId;

    public static class Builder implements IBuilder {
        @Override
        public Parser build(String name) {
            if (TextUtils.equals(name, "TM630CountDownView")) {
                return new TM630CountDownViewParser();
            }
            return null;
        }
    }

    @Override
    public void init() {
        super.init();
        countBgColorId = mStringSupport.getStringId("countBgColor", true);
        countTextColorId = mStringSupport.getStringId("countTextColor", true);
        countTextSizeId = mStringSupport.getStringId("countTextSize", true);
    }

    @Override
    public int convertAttribute(int key, AttrItem value) {
        int ret = super.convertAttribute(key, value);

        if (ViewBaseParser.CONVERT_RESULT_FAILED == ret) {
            ret = ViewBaseParser.CONVERT_RESULT_OK;

            if(key == countBgColorId || key == countTextColorId ){
                if (null != value && !TextUtils.isEmpty(value.mStrValue)) {
                    if (!parseColor(value)) {
                        ret = CONVERT_RESULT_FAILED;
                    }
                } else {
                    Log.e(TAG, "parse color value invalidate:" + value);
                    ret = CONVERT_RESULT_ERROR;
                }
            } else if(key == countTextSizeId){
                if (null != value && !TextUtils.isEmpty(value.mStrValue)) {
                    value.setStr(value.mStrValue);
                } else {
                    Log.e(TAG, "parse string value invalidate:" + value);
                    ret = CONVERT_RESULT_ERROR;
                }
            }else {
                ret = CONVERT_RESULT_FAILED;
            }
        }

        return ret;
    }

    @Override
    public int getId() {
        return BizCommon.TM_COUNTDOWN_VIEW;
    }
}
