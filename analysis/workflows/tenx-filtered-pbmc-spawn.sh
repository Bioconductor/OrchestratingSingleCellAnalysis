# This uses the templated workflow to automatically
# apply the same analysis to each of the PBMC datasets.
# Modifications should be applied to the template rather 
# than any of the individual realizations!

echo -e "<!-- AUTOMATICALLY GENERATED, DO NOT EDIT! -->\n" | cat - <(cat tenx-filtered-pbmc-template.Rmd | sed "s/ID/3k/g")  > tenx-filtered-pbmc3k.Rmd
echo -e "<!-- AUTOMATICALLY GENERATED, DO NOT EDIT! -->\n" | cat - <(cat tenx-filtered-pbmc-template.Rmd | sed "s/ID/4k/g")  > tenx-filtered-pbmc4k.Rmd
