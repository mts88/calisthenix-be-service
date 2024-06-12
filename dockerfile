FROM public.ecr.aws/docker/library/node:20.9-bullseye AS origin

FROM origin AS installer
WORKDIR /app
COPY . .
RUN yarn install

FROM installer AS builder
WORKDIR /app
RUN yarn build && yarn install --production --prefer-offline --ignore-scripts --no-progress --no-audit --no-optional

FROM origin AS runner
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json .
EXPOSE 80

CMD ["yarn", "start:prod"]
