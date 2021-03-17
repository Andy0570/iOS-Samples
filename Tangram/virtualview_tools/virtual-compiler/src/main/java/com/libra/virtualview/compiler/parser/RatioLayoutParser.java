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

package com.libra.virtualview.compiler.parser;

import com.libra.TextUtils;
import com.libra.Log;

import com.libra.virtualview.common.Common;
import com.libra.virtualview.common.StringBase;

/**
 * Created by gujicheng on 16/10/10.
 */
public class RatioLayoutParser extends LayoutParser {
    private final static String TAG = "RatioLayoutParser";

    public static class Builder implements Parser.IBuilder {
        @Override
        public Parser build(String name) {
            if (TextUtils.equals(name, "RatioLayout")) {
                return new RatioLayoutParser();
            }
            return null;
        }
    }

    @Override
    public int getId() {
        return Common.VIEW_ID_RatioLayout;
    }

    @Override
    public int convertAttribute(int key, AttrItem value) {
        int ret = super.convertAttribute(key, value);

        if (CONVERT_RESULT_FAILED == ret) {
            ret = CONVERT_RESULT_OK;
            switch (key) {
                case StringBase.STR_ID_orientation:
                    if (!parseVH(value)) {
                        ret = CONVERT_RESULT_ERROR;
                        Log.e(TAG, "orientation value error:" + value);
                    }
                    break;

                case StringBase.STR_ID_layoutGravity:
                    if (!parseAlign(value)) {
                        Log.e(TAG, "parseAlign error");
                        ret = CONVERT_RESULT_ERROR;
                    }
                    break;

                case StringBase.STR_ID_layoutRatio:
                    if (!parseNumber(value)) {
                        Log.e(TAG, "ratio parse error:" + value);
                        ret = CONVERT_RESULT_ERROR;
                    }
                    break;

                default:
                    ret = CONVERT_RESULT_FAILED;
                    break;
            }
        }

        return ret;
    }
}
