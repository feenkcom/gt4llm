Class {
	#name : #GtLDataSourceRequestParser,
	#superclass : #GtLDataSourceParser,
	#category : #'Gt4Llm-DataSource-Parser'
}

{ #category : #api }
GtLDataSourceRequestParser >> parseRequest: requestResponse at: index for: aMessageConstructor [

	self subclassResponsibility
]
