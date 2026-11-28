"
I am the storage format of a Lepiter page: the LeJsonV4 serialization, as the page is stored on disk, as a JSON object. Its ids are those of the storage format: the page uuid in the dashed form, the snippet uids in uid.uidString, and no database id.
"
Class {
	#name : #GtLLepiterPageStorageContent,
	#superclass : #GtLLepiterPageContent,
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLLepiterPageStorageContent class >> formatName [
	^ 'storage'
]

{ #category : #accessing }
GtLLepiterPageStorageContent >> llmJsonObject [
	"Return the LeJsonV4 serialization of the page as a JSON object, its keys in the stored order"

	^ (NeoJSONReader on: (LeJsonV4 uniqueInstance serialize: page) readStream)
		mapClass: OrderedDictionary;
		next
]
