# hacky method of truncating directory database because I cannot get
# database cleaner to do the job
Before do
  Physician.delete_all
end
