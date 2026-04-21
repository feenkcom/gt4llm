Class {
	#name : #GtOllamaModelInformation,
	#superclass : #GtLlmEntity,
	#instVars : [
		'modelfile',
		'parameters',
		'template',
		'details',
		'modelInfo',
		'license'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaModelInformation class >> leJsonV4Name [

	^ #gtOllamaModelInformation
]

{ #category : #accessing }
GtOllamaModelInformation class >> serializationProperties [
	^ {#modelfile -> #modelfile.
		#parameters -> #parameters.
		#template -> #template.
		#details -> #details.
		#model_info -> #modelInfo.
		#license -> #license
	}
]

{ #category : #accessing }
GtOllamaModelInformation >> details [
	^ details
]

{ #category : #accessing }
GtOllamaModelInformation >> details: anObject [
	details := anObject
]

{ #category : #accessing }
GtOllamaModelInformation >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 8;
		items: [ self details associations ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtOllamaModelInformation >> gtLicenseFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Modelfile';
		priority: 2;
		text: [ self modelfile ]
]

{ #category : #accessing }
GtOllamaModelInformation >> gtModelInfoFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Model info';
		priority: 1;
		items: [ self modelInfo associations ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtOllamaModelInformation >> gtParametersFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Parameters';
		priority: 8;
		items: [ self parameterAssociations ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtOllamaModelInformation >> license [
	^ license
]

{ #category : #accessing }
GtOllamaModelInformation >> license: anObject [
	license := anObject
]

{ #category : #accessing }
GtOllamaModelInformation >> modelInfo [
	^ modelInfo
]

{ #category : #accessing }
GtOllamaModelInformation >> modelInfo: anObject [
	modelInfo := anObject
]

{ #category : #accessing }
GtOllamaModelInformation >> modelfile [
	^ modelfile
]

{ #category : #accessing }
GtOllamaModelInformation >> modelfile: anObject [
	modelfile := anObject
]

{ #category : #accessing }
GtOllamaModelInformation >> parameterAssociations [
	^ ((Character linefeed split: self parameters)
		collect: [ :aLine | 
			| keyAndValue |
			keyAndValue := aLine substrings.
			Association key: keyAndValue first value: keyAndValue second ])
]

{ #category : #accessing }
GtOllamaModelInformation >> parameters [
	^ parameters
]

{ #category : #accessing }
GtOllamaModelInformation >> parameters: anObject [
	parameters := anObject
]

{ #category : #accessing }
GtOllamaModelInformation >> template [
	^ template
]

{ #category : #accessing }
GtOllamaModelInformation >> template: anObject [
	template := anObject
]
