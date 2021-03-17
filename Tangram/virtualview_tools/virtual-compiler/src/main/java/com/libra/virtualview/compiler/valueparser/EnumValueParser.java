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

package com.libra.virtualview.compiler.valueparser;

import java.util.Map;

import com.libra.virtualview.compiler.parser.Parser.AttrItem;

public class EnumValueParser extends BaseValueParser {

	Map<Integer,Map<String, Integer>>  enumMap;
	
	
	public Map<Integer, Map<String, Integer>> getEnumMap() {
		return enumMap;
	}


	public void setEnumMap(Map<Integer, Map<String, Integer>> enumMap) {
		this.enumMap = enumMap;
	}


	@Override
	public boolean parser(AttrItem item) {
		Map<String, Integer> m = enumMap.get(this.getKeyInt());
		if(m == null || !m.containsKey(item.mStrValue.toUpperCase())){
			return false;
		}
		
		int value = m.get(item.mStrValue.toUpperCase());
		item.setIntValue(value);
		
		return true;
	}

}
