Class {
	#name : #GtLDataSourceResponseParser,
	#superclass : #GtLDataSourceParser,
	#category : #'Gt4Llm-DataSource-Parser'
}

{ #category : #api }
GtLDataSourceResponseParser >> parseResponse: requestResponse message: message for: aMessageConstructor [

	self subclassResponsibility
]
