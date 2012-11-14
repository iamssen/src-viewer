package ssen.srcviewer.services {
import ssen.datakit.tokens.IAsyncToken;

public interface IFileService {
	function getFileList():IAsyncToken;
}
}
