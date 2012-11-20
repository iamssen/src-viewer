package ssen.srcviewer.model.filetypes {
import org.antlr.runtime.ParserRuleReturnScope;
import org.antlr.runtime.RecognitionException;
import org.as3commons.asblocks.dom.IASClassType;
import org.as3commons.asblocks.dom.IASCompilationUnit;
import org.as3commons.asblocks.dom.IASField;
import org.as3commons.asblocks.dom.IASMethod;
import org.as3commons.asblocks.dom.Visibility;
import org.as3commons.asblocks.impl.ASTASCompilationUnit;
import org.as3commons.asblocks.impl.ASTUtils;
import org.as3commons.asblocks.impl.FileUtil;
import org.as3commons.asblocks.parser.antlr.LinkedListTree;
import org.as3commons.asblocks.parser.antlr.as3.AS3Parser;
import org.as3commons.collections.framework.IIterator;

public class ActionScript extends Code {
	
	override public function getAPI():String {
		var source:String=getSource();
		
		// class, interface, function, variable 구분이 필요?
		// https://github.com/teotigraphix/as3-commons-asblocks 사용해서 파싱
		
		var parser:AS3Parser=ASTUtils.parseFile(FileUtil.newFile(file.nativePath));
		var tree:LinkedListTree;
		try {
			tree=ParserRuleReturnScope(parser.compilationUnit()).tree as LinkedListTree;
		} catch (e:RecognitionException) {
			throw ASTUtils.buildSyntaxException(null, parser, e);
		}
		
		var unit:IASCompilationUnit=new ASTASCompilationUnit(tree);
		var ctype:IASClassType=unit.getType() as IASClassType;
		
		trace("ActionScript.getAPI() package is", unit.getPackageName());
		trace("ActionScript.getAPI() class is", ctype.getName());
		trace("ActionScript.getAPI() extends", ctype.getSuperClass());
		
		var f:IIterator, s:IIterator, th:IIterator;
		
		var intf:String;
		var field:IASField;
		var method:IASMethod;
		
		f=ctype.getImplementedInterfaces().iterator();
		while (f.hasNext()) {
			intf=f.next();
			trace("implement :::", intf);
		}
		
		f=ctype.getFields().iterator();
		while (f.hasNext()) {
			field=f.next();
			
			if (field.getVisibility() === Visibility.PUBLIC) {
				trace("field :::", field.getName(), field.getType(), field.getInitializer(), field.getVisibility());
			}
		}
		
		f=ctype.getMethods().iterator();
		while (f.hasNext()) {
			method=f.next();
			
			if (field.getVisibility() === Visibility.PUBLIC) {
				trace("method :::", method.getName(), method.getParameters(), field.getInitializer(), field.getVisibility());
				
				s=method.getParameters().iterator();
				
				while (s.hasNext()) {
					trace("	method parameter :::", s.next());
				}
			}
		}
		
		//		assertEquals("foo.bar", unit.getPackageName());
		//		assertEquals("Baz", ctype.getName());
		//		assertEquals("Baz2", ctype.getSuperClass());
		//		assertEquals(2, ctype.getImplementedInterfaces().size);
		
		return '## API\n- aaaa\n- bbb\n- ccc';
	}
	
	override public function hasAPI():Boolean {
		return true;
	}
}
}
