import React from 'react'
import ReactDOM from 'react-dom'
import MediaUploader from 'harmonium/lib/MediaUploader'

async function s3Info(file) {
  // skipping the try/catch here since this function is getting called inside of a try/catch block
  const response = await fetch(`/images/sign?file_name=${file.name}`)
  const {data} = await response.json()

  return {signedRequestUrl: data.signed_request, fileUrl: data.url}
}

async function init() {
  const uploader = document.querySelector('[data-media-uploader]')
  const existingLogoUrl = uploader.dataset.logoUrl
  const name = uploader.dataset.inputName

  ReactDOM.render(
    <MediaUploader
      name={name}
      getS3Info={s3Info}
      defaultPreview={existingLogoUrl}
      supportedFileTypes={['image/png', 'image/jpg', 'image/jpeg', 'image/gif']}
    />,
    uploader,
  )
  return null
}

export default {
  init,
}
