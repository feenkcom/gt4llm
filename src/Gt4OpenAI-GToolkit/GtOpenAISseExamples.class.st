Class {
	#name : #GtOpenAISseExamples,
	#superclass : #Object,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtOpenAISseExamples >> complexStreamExample [
	^ ('event: response.created
data: {"response":{"error":null,"incomplete_details":null,"tools":[{"parameters":{"type":"object","properties":{"pageName":{"type":"string"}},"required":["pageName"],"additionalProperties":false},"description":"Looks up a documentation page by name and returns its content in Markdown format. `pageName` may be a substring. If multiple pages are found, only the first one will be returned.","strict":true,"name":"lookupDocumentationPage","type":"function"}],"tool_choice":"auto","temperature":1.0,"user":null,"metadata":{},"store":true,"max_output_tokens":null,"model":"gpt-4o-2024-08-06","object":"response","instructions":null,"truncation":"disabled","reasoning":{"summary":null,"effort":null},"created_at":1744888532,"service_tier":"auto","text":{"format":{"type":"text"}},"previous_response_id":null,"output":[],"top_p":1.0,"id":"resp_6800e2d488108191bb08019e3c7532530a8a3b265fbee795","parallel_tool_calls":true,"status":"in_progress","usage":null},"type":"response.created"}

event: response.in_progress
data: {"response":{"error":null,"incomplete_details":null,"tools":[{"parameters":{"type":"object","properties":{"pageName":{"type":"string"}},"required":["pageName"],"additionalProperties":false},"description":"Looks up a documentation page by name and returns its content in Markdown format. `pageName` may be a substring. If multiple pages are found, only the first one will be returned.","strict":true,"name":"lookupDocumentationPage","type":"function"}],"tool_choice":"auto","temperature":1.0,"user":null,"metadata":{},"store":true,"max_output_tokens":null,"model":"gpt-4o-2024-08-06","object":"response","instructions":null,"truncation":"disabled","reasoning":{"summary":null,"effort":null},"created_at":1744888532,"service_tier":"auto","text":{"format":{"type":"text"}},"previous_response_id":null,"output":[],"top_p":1.0,"id":"resp_6800e2d488108191bb08019e3c7532530a8a3b265fbee795","parallel_tool_calls":true,"status":"in_progress","usage":null},"type":"response.in_progress"}

event: response.output_item.added
data: {"item":{"status":"in_progress","content":[],"role":"assistant","id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","type":"message"},"output_index":0,"type":"response.output_item.added"}

event: response.content_part.added
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","part":{"text":"","annotations":[],"type":"output_text"},"type":"response.content_part.added"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"`","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"gt","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"4","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"ll","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"m","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"`","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" is","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" a","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" framework","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" that","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" enables","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" interaction","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" with","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Large","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Language","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Models","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" (","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"LL","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"Ms","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":")","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" within","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Glam","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"orous","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Toolkit","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":".","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" It","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" supports","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" functionalities","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" like","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" chatting","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" with","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" L","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"LM","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"s","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":",","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" managing","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" models","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":",","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" fine","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"-t","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"uning","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":",","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" and","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" creating","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" custom","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" prompts","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" and","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" assistants","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":".\n\n","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"###","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Key","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Integr","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"ations","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":":\n\n","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"-","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" **","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"Open","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"AI","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"**","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":":","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" The","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" most","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" advanced","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" integration","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":",","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" requiring","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" API","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" key","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" setup","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":".","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" More","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" information","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" can","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" be","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" found","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" in","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" the","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" \"","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"Working","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" with","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Open","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"AI","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"\"","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" section","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":".\n","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"-","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" **","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"O","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"ll","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"ama","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"**","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":":","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Includes","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" basic","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" API","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" access","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" and","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" more","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" advanced","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" concepts","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" like","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" structured","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" outputs","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" and","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" mod","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"elf","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"iles","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":".\n","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"-","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" **","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"Anth","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"ropic","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"**","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":":","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Offers","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" simple","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" integration","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":",","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" supporting","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" chat","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" use","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" cases","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" and","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" tool","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" calls","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":".\n\n","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"For","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" more","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" detailed","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" studies","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" and","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" examples","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":",","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" refer","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" to","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" case","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" studies","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" on","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" building","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" L","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"LM","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" assistants","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" for","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" editing","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" blog","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" posts","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" and","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" creating","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Ward","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":"ley","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":" Maps","type":"response.output_text.delta"}

event: response.output_text.delta
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","delta":".","type":"response.output_text.delta"}

event: response.output_text.done
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","type":"response.output_text.done","text":"`gt4llm` is a framework that enables interaction with Large Language Models (LLMs) within Glamorous Toolkit. It supports functionalities like chatting with LLMs, managing models, fine-tuning, and creating custom prompts and assistants.\n\n### Key Integrations:\n\n- **OpenAI**: The most advanced integration, requiring API key setup. More information can be found in the \"Working with OpenAI\" section.\n- **Ollama**: Includes basic API access and more advanced concepts like structured outputs and modelfiles.\n- **Anthropic**: Offers simple integration, supporting chat use cases and tool calls.\n\nFor more detailed studies and examples, refer to case studies on building LLM assistants for editing blog posts and creating Wardley Maps."}

event: response.content_part.done
data: {"output_index":0,"content_index":0,"item_id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","part":{"text":"`gt4llm` is a framework that enables interaction with Large Language Models (LLMs) within Glamorous Toolkit. It supports functionalities like chatting with LLMs, managing models, fine-tuning, and creating custom prompts and assistants.\n\n### Key Integrations:\n\n- **OpenAI**: The most advanced integration, requiring API key setup. More information can be found in the \"Working with OpenAI\" section.\n- **Ollama**: Includes basic API access and more advanced concepts like structured outputs and modelfiles.\n- **Anthropic**: Offers simple integration, supporting chat use cases and tool calls.\n\nFor more detailed studies and examples, refer to case studies on building LLM assistants for editing blog posts and creating Wardley Maps.","annotations":[],"type":"output_text"},"type":"response.content_part.done"}

event: response.output_item.done
data: {"item":{"status":"completed","content":[{"text":"`gt4llm` is a framework that enables interaction with Large Language Models (LLMs) within Glamorous Toolkit. It supports functionalities like chatting with LLMs, managing models, fine-tuning, and creating custom prompts and assistants.\n\n### Key Integrations:\n\n- **OpenAI**: The most advanced integration, requiring API key setup. More information can be found in the \"Working with OpenAI\" section.\n- **Ollama**: Includes basic API access and more advanced concepts like structured outputs and modelfiles.\n- **Anthropic**: Offers simple integration, supporting chat use cases and tool calls.\n\nFor more detailed studies and examples, refer to case studies on building LLM assistants for editing blog posts and creating Wardley Maps.","annotations":[],"type":"output_text"}],"role":"assistant","id":"msg_6800e2d4f1988191b4a93df469f0f97a0a8a3b265fbee795","type":"message"},"output_index":0,"type":"response.output_item.done"}

event: response.completed
data:  {}'
		copyReplaceAll: '
'
		with: Character linefeed asString) utf8Encoded readStream
]

{ #category : #'as yet unclassified' }
GtOpenAISseExamples >> onComplexStream [
	<gtExample>
	| stream |
	stream := GtOpenAISseStream new stream: self complexStreamExample.

	stream waitForCompletion.

	self assert: stream events size equals: 160.
	self assert: (stream eventsOfType: 'response.output_text.delta') size equals: 152.
	self
		assert: (''
				join: ((stream eventsOfType: 'response.output_text.delta')
						collect: [ :anEvent | anEvent data at: 'delta' ]))
		equals: ('`gt4llm` is a framework that enables interaction with Large Language Models (LLMs) within Glamorous Toolkit. It supports functionalities like chatting with LLMs, managing models, fine-tuning, and creating custom prompts and assistants.

### Key Integrations:

- **OpenAI**: The most advanced integration, requiring API key setup. More information can be found in the "Working with OpenAI" section.
- **Ollama**: Includes basic API access and more advanced concepts like structured outputs and modelfiles.
- **Anthropic**: Offers simple integration, supporting chat use cases and tool calls.

For more detailed studies and examples, refer to case studies on building LLM assistants for editing blog posts and creating Wardley Maps.' copyReplaceAll: String cr with: String lf).

	^ stream
]

{ #category : #'as yet unclassified' }
GtOpenAISseExamples >> onSimpleStream [
	<gtExample>
	| stream |
	stream := GtOpenAISseStream new stream: self simpleStreamExample.
	
	stream waitForCompletion.
	
	self assert: stream events size equals: 2.
	self assert: stream events first eventType equals: 'response.started'.
	self assert: stream events first data keys equals: {'hi'. 'λαμβδα'}.
	self assert: stream events second data equals: {} asDictionary.
	
	^ stream
]

{ #category : #'as yet unclassified' }
GtOpenAISseExamples >> simpleStreamExample [
	<gtExample>
	^ ('event: response.started
data: {"hi": 15, "λαμβδα": "unicode"}

event: response.completed
data:  {}'
		copyReplaceAll: '
'
		with: Character linefeed asString) utf8Encoded readStream
]
