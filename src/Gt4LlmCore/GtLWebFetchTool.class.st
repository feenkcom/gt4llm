Class {
	#name : #GtLWebFetchTool,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLWebFetchTool >> description [
	^ 'Fetch a single web page by URL and return its content.
	
Example JSON arguments:
{ "url": "https://example.com" }

Example JSON response:
{
  "title": "Example Domain",
	"content": "<!doctype html>...</html>",
  "links": [ "https://example.com" ]
}'
]

{ #category : #'as yet unclassified' }
GtLWebFetchTool >> formattedLinksIn: doc [

	^ (doc allElementsNamed: 'a') collect: [ :element |
		String streamContents: [ :stream |
			stream
				<< '[';
				<< element contentString asString;
				<< '](';
				<< (element attributeNodeAt: 'href') value asString;
				<< ')' ] ]
		as: Array.
]

{ #category : #private }
GtLWebFetchTool >> get: aUrl [
	| url znClient znResponse result doc title links response |

	url := aUrl.
	((url beginsWith: 'http://') or:
	[ url beginsWith: 'https://' ]) ifFalse:
		[ self error: 'The supplied URL must begin with http:// or https://' ].

	znClient := ZnClient new.
	znClient get: url.
	znResponse := znClient response.
	znResponse isSuccess ifFalse:
		[ znResponse inspect.
		 ^ {
			'error' -> 'Unable to retrieve the URL'.
			} asDictionary. ].
	result := znResponse contents.
	doc := XMLHTMLParser parse: result.
	links := self formattedLinksIn: doc.
	title := self titleIn: doc.

	response := NeoJSONWriter toString: {
		'title' -> title.
		'content' -> result.
		'links' -> links.
		} asDictionary.

	^ GtLPlainJson forString: response
]

{ #category : #accessing }
GtLWebFetchTool >> name [

	^ 'WebFetch'
]

{ #category : #'as yet unclassified' }
GtLWebFetchTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| url |

	url := aToolCall arguments at: 'url'
		ifAbsent: [ aToolCall rawArguments at: 'url' ].
	^ self get: url.
]

{ #category : #'as yet unclassified' }
GtLWebFetchTool >> titleIn: doc [

	^ (doc allElementsNamed: 'title') first contentString
]
